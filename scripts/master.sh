#!/bin/bash
#
# Setup for Control Plane (Master) servers

set -euxo pipefail

# Set non-interactive mode for APT
export DEBIAN_FRONTEND=noninteractive

NODENAME=$(hostname -s)

# Clean up existing Kubernetes setup (if any)
sudo kubeadm reset -f || true
sudo rm -rf /etc/kubernetes /var/lib/etcd /var/lib/kubelet /etc/cni/net.d || true

# Preload Kubernetes images
sudo kubeadm config images pull

echo "Preflight Check Passed: Downloaded All Required Images"

#sudo kubeadm init --apiserver-advertise-address=$CONTROL_IP --apiserver-cert-extra-sans=$CONTROL_IP --pod-network-cidr=$POD_CIDR --service-cidr=$SERVICE_CIDR --node-name "$NODENAME" --ignore-preflight-errors Swap

# Initialize the Kubernetes cluster
if [ ! -f /etc/kubernetes/admin.conf ]; then
  sudo kubeadm init --apiserver-advertise-address=$CONTROL_IP --apiserver-cert-extra-sans=$CONTROL_IP --pod-network-cidr=$POD_CIDR --service-cidr=$SERVICE_CIDR --node-name "$NODENAME" --ignore-preflight-errors Swap
else
  echo "Kubernetes is already initialized. Skipping kubeadm init."
fi

# Configure kubectl for the vagrant user
mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config

# Save Configurations to Shared Vagrant Location
config_path="/vagrant/configs"

if [ -d $config_path ]; then
  rm -f $config_path/*
else
  mkdir -p $config_path
fi

cp -i /etc/kubernetes/admin.conf $config_path/config
touch $config_path/join.sh
chmod +x $config_path/join.sh

kubeadm token create --print-join-command > $config_path/join.sh

# Install Calico Network Plugin
curl -fsSL https://raw.githubusercontent.com/projectcalico/calico/v${CALICO_VERSION}/manifests/calico.yaml -o calico.yaml

kubectl apply -f calico.yaml

# Configure kubectl for the vagrant user
sudo -i -u vagrant bash << EOF
mkdir -p /home/vagrant/.kube
sudo cp -i $config_path/config /home/vagrant/.kube/
sudo chown 1000:1000 /home/vagrant/.kube/config
EOF

# Install Metrics Server
kubectl apply -f https://raw.githubusercontent.com/techiescamp/kubeadm-scripts/main/manifests/metrics-server.yaml
kubectl rollout restart deployment -n kube-system metrics-server
sudo systemctl restart kubelet