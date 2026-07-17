# ------------------------------------------------------------
# Linux Cloud Image Download
# ------------------------------------------------------------
resource "proxmox_download_file" "linux_cloud_image" {
  content_type        = "import"
  datastore_id        = var.image_datastore_id
  node_name           = var.proxmox_node
  url                 = var.linux_cloud_image_url
  file_name           = var.linux_cloud_image_filename
  overwrite           = true
  overwrite_unmanaged = true
}

# Renders the cloud-init template and uploads it as a snippet so the VM's
# initialization block can reference it via user_data_file_id.
resource "proxmox_virtual_environment_file" "forgejo_userdata" {
  content_type = "snippets"
  datastore_id = var.snippet_datastore
  node_name    = var.proxmox_node

  source_raw {
    file_name = "forgejo-userdata.yaml"
    data = templatefile("${path.module}/cloud-init/forgejo-userdata.yaml.tftpl", {
      ssh_public_keys       = [trimspace(data.local_file.ssh_public_key.content)]
      ci_user_password_hash = var.ci_user_password_hash
      forgejo_db_password   = var.forgejo_db_password
    })
  }
}

resource "proxmox_virtual_environment_vm" "forgejo" {
  name      = var.vm_name
  node_name = var.proxmox_node
  vm_id     = var.vm_id
  tags      = ["cicd", "forgejo", "terraform"]

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

    user_data_file_id = proxmox_virtual_environment_file.forgejo_userdata.id
  }

  operating_system {
    type = "l26"
  }

  # Keep this VM off the node carrying your primary HDD/PBS pool -
  # set proxmox_node accordingly rather than relying on scheduling.
  lifecycle {
    ignore_changes = [
      clone,
    ]
  }
}

output "forgejo_vm_ip" {
  value = var.ip_address_cidr
}
