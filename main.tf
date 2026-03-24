terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.78.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = var.proxmox_insecure

  ssh {
    agent    = true
    username = var.proxmox_ssh_username
  }
}

resource "proxmox_virtual_environment_container" "debian13" {
  description  = "Debian 13 LXC managed by Terraform"
  node_name    = var.proxmox_node
  vm_id        = var.container_id
  tags         = ["terraform", "debian13"]
  started      = true
  unprivileged = true

  initialization {
    hostname = var.container_hostname

    user_account {
      keys     = var.ssh_public_keys
      password = var.root_password
    }
  }

  operating_system {
    template_file_id = var.template_file_id
    type             = "debian"
  }

  cpu {
    cores = var.cpu_cores
  }

  memory {
    dedicated = var.memory_mb
    swap      = var.swap_mb
  }

  disk {
    datastore_id = var.storage_datastore
    size         = var.disk_size_gb
  }

  network_interface {
    name     = "eth0"
    bridge   = var.network_bridge
    firewall = false
  }

  features {
    nesting = var.enable_nesting
  }

  lifecycle {
    ignore_changes = [
      initialization[0].user_account[0].password,
    ]
  }
}

