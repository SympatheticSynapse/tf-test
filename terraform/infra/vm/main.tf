# ------------------------------------------------------------
# Linux Cloud Image Download
# ------------------------------------------------------------
resource "proxmox_download_file" "linux_cloud_image" {
  for_each            = var.proxmox_nodes
  content_type        = "import"
  datastore_id        = var.image_datastore_id
  node_name           = each.key
  url                 = var.linux_cloud_image_url
  file_name           = var.linux_cloud_image_filename
  overwrite           = true
  overwrite_unmanaged = true # allows adopting/replacing files Terraform doesn't already track
}

# ------------------------------------------------------------
# Control Plane VMs (one per noded)
# ------------------------------------------------------------
resource "proxmox_virtual_environment_vm" "control_plane" {
  for_each  = var.proxmox_nodes
  name      = "k8s-cp-${each.key}"
  node_name = each.key
  vm_id     = each.value.cp_vmid

  stop_on_destroy = var.vm_stop_on_destroy

  cpu {
    cores   = var.vm_cpu_cores
    sockets = var.vm_cpu_sockets
    type    = var.vm_cpu_type
  }

  memory {
    dedicated = var.vm_memory_mb
  }

  disk {
    datastore_id = each.value.datastore_id
    import_from  = proxmox_download_file.linux_cloud_image[each.key].id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = var.vm_disk_size_gb
  }

  network_device {
    bridge   = var.vm_network_bridge
    model    = var.vm_network_model
    firewall = var.vm_network_firewall
  }

  # Recommended: enable QEMU guest agent if installed in cloud image
  agent {
    enabled = var.vm_agent_enabled
  }

  # Recommended: set OS type for better defaults
  operating_system {
    type = "l26" # Linux 2.6+ kernel
  }

  # Recommended: enable SCSI hardware for better disk performance
  scsi_hardware = "virtio-scsi-single"

  initialization {
    datastore_id = each.value.datastore_id

    ip_config {
      ipv4 {
        address = each.value.cp_ip
        gateway = var.vm_ipv4_gateway
      }
    }

    user_account {
      username = var.vm_username
      password = var.vm_password
      keys     = [trimspace(data.local_file.ssh_public_key.content)]
    }
  }
}

# ------------------------------------------------------------
# Worker VMs (one per noded)
# ------------------------------------------------------------
resource "proxmox_virtual_environment_vm" "worker" {
  for_each  = var.proxmox_nodes
  name      = "k8s-wk-${each.key}"
  node_name = each.key
  vm_id     = each.value.worker_vmid

  stop_on_destroy = var.vm_stop_on_destroy

  cpu {
    cores   = var.vm_cpu_cores
    sockets = var.vm_cpu_sockets
    type    = var.vm_cpu_type
  }

  memory {
    dedicated = var.vm_memory_mb
  }

  disk {
    datastore_id = each.value.datastore_id
    import_from  = proxmox_download_file.linux_cloud_image[each.key].id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = var.vm_disk_size_gb
  }

  network_device {
    bridge   = var.vm_network_bridge
    model    = var.vm_network_model
    firewall = var.vm_network_firewall
  }

  # Recommended: enable QEMU guest agent if installed in cloud image
  agent {
    enabled = var.vm_agent_enabled
  }

  # Recommended: set OS type for better defaults
  operating_system {
    type = "l26" # Linux 2.6+ kernel
  }

  # Recommended: enable SCSI hardware for better disk performance
  scsi_hardware = "virtio-scsi-single"

  initialization {
    datastore_id = each.value.datastore_id

    ip_config {
      ipv4 {
        address = each.value.worker_ip
        gateway = var.vm_ipv4_gateway
      }
    }

    user_account {
      username = var.vm_username
      password = var.vm_password
      keys     = [trimspace(data.local_file.ssh_public_key.content)]
    }
  }
}
