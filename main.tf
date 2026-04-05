terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.99"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.7"
    }
  }
  required_version = ">= 1.5"
}

provider "proxmox" {
  endpoint  = var.proxmox_endpoint
  api_token = var.proxmox_api_token
  insecure  = var.proxmox_insecure
}

data "local_file" "ssh_public_key" {
  filename = "/Users/corelinkmobile/.ssh/id_rsa.pub"
}

resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name      = "test-ubuntu"
  node_name = "core-lab"

  # should be true if qemu agent is not installed / enabled on the VM
  stop_on_destroy = true

  initialization {
    # uncomment and specify the datastore for cloud-init disk if default `local-lvm` is not available
    # datastore_id = "local-lvm"

    ip_config {
      ipv4 {
        address = "192.168.3.233/24"
        gateway = "192.168.3.1"
      }
    }

    user_account {
      username = "ubuntu"
      keys     = [trimspace(data.local_file.ssh_public_key.content)]
    }
  }

  disk {
    datastore_id = "local-lvm"
    import_from  = proxmox_virtual_environment_download_file.ubuntu_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 20
  }

  network_device {
    bridge = "vmbr0"
  }
}

resource "proxmox_virtual_environment_download_file" "ubuntu_cloud_image" {
  content_type = "import"
  datastore_id = "local"
  node_name    = "core-lab"
  url          = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  # need to rename the file to *.qcow2 to indicate the actual file format for import
  file_name = "jammy-server-cloudimg-amd64.qcow2"
}

# ------------------------------------------------------------
# NFS Storage Resources
# ------------------------------------------------------------
resource "proxmox_virtual_environment_storage_nfs" "nfs" {
  for_each = { for share in var.nfs_shares : share.id => share }

  id      = each.value.id
  nodes   = var.proxmox_nodes
  server  = var.nas_ip
  export  = each.value.export
  content = each.value.content
  options = "vers=3"
}
