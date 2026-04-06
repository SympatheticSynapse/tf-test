# ------------------------------------------------------------
# Ubuntu Cloud Image Download
# ------------------------------------------------------------
resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = "import"
  datastore_id = var.image_datastore_id
  node_name    = var.proxmox_node_name
  url          = var.ubuntu_cloud_image_url
  file_name    = var.ubuntu_cloud_image_filename
}

# ------------------------------------------------------------
# Ubuntu VM
# ------------------------------------------------------------
resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name      = var.vm_name
  node_name = var.proxmox_node_name

  stop_on_destroy = var.vm_stop_on_destroy

  cpu {
    cores   = var.vm_cpu_cores
    sockets = var.vm_cpu_sockets
    type    = var.vm_cpu_type
  }

  memory {
    dedicated = var.vm_memory_mb
  }

  initialization {
    datastore_id = var.vm_disk_datastore_id

    ip_config {
      ipv4 {
        address = var.vm_ipv4_address
        gateway = var.vm_ipv4_gateway
      }
    }

    user_account {
      username = var.vm_username
      password = var.vm_password
      keys     = [trimspace(data.local_file.ssh_public_key.content)]
    }
  }

  disk {
    datastore_id = var.vm_disk_datastore_id
    import_from  = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
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
}
