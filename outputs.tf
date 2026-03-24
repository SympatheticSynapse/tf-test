output "container_id" {
  description = "The VM/CT ID of the deployed container"
  value       = proxmox_virtual_environment_container.debian13.vm_id
}

output "container_hostname" {
  description = "Hostname of the container"
  value       = proxmox_virtual_environment_container.debian13.initialization[0].hostname
}

output "container_node" {
  description = "Proxmox node the container is running on"
  value       = proxmox_virtual_environment_container.debian13.node_name
}

output "container_tags" {
  description = "Tags applied to the container"
  value       = proxmox_virtual_environment_container.debian13.tags
}

