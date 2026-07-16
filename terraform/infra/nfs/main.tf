resource "proxmox_storage_nfs" "nfs" {
  for_each = { for share in var.nfs_shares : share.id => share }

  id      = each.value.id
  server  = var.nas_ip
  export  = each.value.export
  content = each.value.content
  options = var.nfs_options
}
