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
  - mkdir -p /var/lib/rancher/rke2/server/manifests
  - curl -fsSL https://kube-vip.io/manifests/rbac.yaml -o /var/lib/rancher/rke2/server/manifests/kube-vip-rbac.yaml
  - |
    cat <<EOF > /var/lib/rancher/rke2/server/manifests/kube-vip.yaml
    apiVersion: apps/v1
    kind: DaemonSet
    metadata:
      name: kube-vip-ds
      namespace: kube-system
    spec:
      selector:
        matchLabels:
          name: kube-vip-ds
      template:
        metadata:
          labels:
            name: kube-vip-ds
        spec:
          affinity:
            nodeAffinity:
              requiredDuringSchedulingIgnoredDuringExecution:
                nodeSelectorTerms:
                - matchExpressions:
                  - key: node-role.kubernetes.io/master
                    operator: Exists
                - matchExpressions:
                  - key: node-role.kubernetes.io/control-plane
                    operator: Exists
          containers:
          - name: kube-vip
            image: ghcr.io/kube-vip/kube-vip:${kube_vip_version}
            imagePullPolicy: IfNotPresent
            args: ["manager"]
            env:
            - name: vip_arp
              value: "true"
            - name: port
              value: "6443"
            - name: vip_interface
              value: "${vip_interface}"
            - name: vip_subnet
              value: "32"
            - name: cp_enable
              value: "true"
            - name: cp_namespace
              value: kube-system
            - name: vip_ddns
              value: "false"
            - name: svc_enable
              value: "false"
            - name: vip_leaderelection
              value: "true"
            - name: vip_leaseduration
              value: "5"
            - name: vip_renewdeadline
              value: "3"
            - name: vip_retryperiod
              value: "1"
            - name: address
              value: "${cluster_vip}"
            securityContext:
              capabilities:
                add:
                - NET_ADMIN
                - NET_RAW
                - SYS_TIME
          hostNetwork: true
          serviceAccountName: kube-vip
          tolerations:
          - effect: NoSchedule
            operator: Exists
          - effect: NoExecute
            operator: Exists
    EOF
  - curl -sfL https://get.rke2.io | INSTALL_RKE2_VERSION=${rke2_version} INSTALL_RKE2_TYPE=server sh -
  - systemctl enable rke2-server.service
  - systemctl start rke2-server.service
  - ln -sf /var/lib/rancher/rke2/bin/kubectl /usr/local/bin/kubectl
  - ln -sf /var/lib/rancher/rke2/agent/etc/cni/net.d /etc/cni/net.d
