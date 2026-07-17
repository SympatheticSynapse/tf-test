ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null test@10.10.200.181 "sudo cat /etc/rancher/rke2/rke2.yaml" >~/.kube/rke2-homelab.yaml
sed -i '' "s/127.0.0.1/10.10.200.181/" ~/.kube/rke2-homelab.yaml # macOS sed, empty '' required
export KUBECONFIG=~/.kube/rke2-homelab.yaml
