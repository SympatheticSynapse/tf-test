#cloud-config
package_update: true
runcmd:
  - apt-get update && apt-get install -y qemu-guest-agent
  - systemctl enable --now qemu-guest-agent
  - mkdir -p /etc/rancher/rke2
  - |
    cat <<EOF > /etc/rancher/rke2/config.yaml
    server: "${server_url}"
    token: "${rke2_token}"
    EOF
  - curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION=${rke2_version} INSTALL_RKE2_TYPE=agent sh -
  - systemctl enable rke2-agent.service
  - systemctl start rke2-agent.service
