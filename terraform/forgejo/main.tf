# Renders the cloud-init template and uploads it as a snippet so the VM's
# initialization block can reference it via user_data_file_id.
resource "proxmox_virtual_environment_file" "forgejo_userdata" {
  content_type = "snippets"
  datastore_id = var.snippet_datastore
  node_name    = var.proxmox_node

  source_raw {
    file_name = "forgejo-userdata.yaml"
    data = templatefile("${path.module}/cloud-init/forgejo-userdata.yaml.tftpl", {
      ssh_public_keys       = var.ssh_public_keys
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

  clone {
    vm_id = var.template_vm_id
    full  = true
  }

  cpu {
    cores = var.cores
    type  = "host"
  }

  memory {
    dedicated = var.memory_mb
  }

  agent {
    enabled = true
  }

  disk {
    datastore_id = var.disk_datastore
    interface    = "scsi0"
    size         = var.disk_size_gb
    file_format  = "raw"
    ssd          = true
    discard      = "on"
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
