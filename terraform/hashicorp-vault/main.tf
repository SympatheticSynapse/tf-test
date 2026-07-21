resource "proxmox_download_file" "linux_cloud_image" {
  content_type        = "import"
  datastore_id        = var.image_datastore_id
  node_name           = var.proxmox_node
  url                 = var.linux_cloud_image_url
  file_name           = var.linux_cloud_image_filename
  overwrite           = true
  overwrite_unmanaged = true
}

resource "proxmox_virtual_environment_file" "vault_userdata" {
  content_type = "snippets"
  datastore_id = var.snippet_datastore
  node_name    = var.proxmox_node

  source_raw {
    file_name = "vault-userdata.yaml"
    data = templatefile("${path.module}/cloud-init/vault-userdata.yaml.tftpl", {
      ssh_public_keys       = [trimspace(data.local_file.ssh_public_key.content)]
      ci_user_password_hash = var.ci_user_password_hash
      vault_version         = var.vault_version
      vault_domain          = var.vault_domain
    })
  }
}

resource "proxmox_virtual_environment_vm" "vault" {
  name      = var.vm_name
  node_name = var.proxmox_node
  vm_id     = var.vm_id
  tags      = ["vault", "secrets", "terraform"]

  cpu {
    cores = var.cores
    type  = "host"
  }

  memory {
    dedicated = var.memory_mb
  }

  agent {
    enabled = true
    timeout = "30s"
  }

  scsi_hardware = "virtio-scsi-single"

  disk {
    datastore_id = var.disk_datastore
    import_from  = proxmox_download_file.linux_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = var.disk_size_gb
  }

  network_device {
    bridge = var.network_bridge
  }

  initialization {
    datastore_id = var.disk_datastore

    ip_config {
      ipv4 {
        address = var.ip_address_cidr
        gateway = var.gateway
      }
    }

    dns {
      servers = var.dns_servers
    }

    user_data_file_id = proxmox_virtual_environment_file.vault_userdata.id
  }

  operating_system {
    type = "l26"
  }
}

output "vault_vm_ip" {
  value = var.ip_address_cidr
}
