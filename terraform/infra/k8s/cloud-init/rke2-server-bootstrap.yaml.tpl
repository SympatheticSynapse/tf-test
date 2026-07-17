#cloud-config
package_update: true
runcmd:
  - apt-get update && apt-get install -y qemu-guest-agent
  - systemctl enable --now qemu-guest-agent
  - mkdir -p /etc/rancher/rke2
  - |
    cat <<EOF > /etc/rancher/rke2/config.yaml
    token: "${rke2_token}"
    tls-san:
      - "${tls_san}"
    write-kubeconfig-mode: "0644"
    EOF
  - curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION=${rke2_version} INSTALL_RKE2_TYPE=server sh -
  - systemctl enable rke2-server.service
  - systemctl start rke2-server.service
  - ln -sf /var/lib/rancher/rke2/bin/kubectl /usr/local/bin/kubectl
  - ln -sf /var/lib/rancher/rke2/agent/etc/cni/net.d /etc/cni/net.d
