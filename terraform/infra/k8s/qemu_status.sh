for ip in 181 182 183 184 185 186; do
  echo "=== $ip ==="
  ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null test@10.10.200.${ip} "systemctl status qemu-guest-agent --no-pager"
done
