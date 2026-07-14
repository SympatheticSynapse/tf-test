output "control_plane_ips" {
  value = { for k, v in var.proxmox_nodes : k => v.cp_ip }
}

output "worker_ips" {
  value = { for k, v in var.proxmox_nodes : k => v.worker_ip }
}

