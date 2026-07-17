for ip in 181 182 183 184 185 186; do
  echo "=== $ip ==="
  ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null k8s_admin@10.10.200.${ip} "uptime; sudo systemctl is-active rke2-server rke2-agent 2>&1"
  ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null k8s_admin@10.10.200.${ip} "sudo systemctl status rke2-server --no-pager -l"
  ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null k8s_admin@10.10.200.${ip} "sudo journalctl -u rke2-server -n 30 --no-pager"
done
