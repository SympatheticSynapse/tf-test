# ------------------------------------------------------------
# Proxmox Provider
# ------------------------------------------------------------
variable "proxmox_api_url" {
  description = "URL of the Proxmox API endpoint (e.g., https://192.168.3.10:8006)"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token in the format 'USER@REALM!TOKENID=SECRET'"
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Skip TLS verification for the Proxmox API (set to false in production)"
  type        = bool
  default     = false
}


# ------------------------------------------------------------
# Cluster topology — one CP VM + one worker VM per Proxmox node
# ------------------------------------------------------------
variable "proxmox_nodes" {
  description = "Map of Proxmox node name -> IPs/VMIDs for its control-plane and worker VM"
  type = map(object({
    cp_ip        = string
    worker_ip    = string
    cp_vmid      = number
    worker_vmid  = number
    datastore_id = string
  }))
  default = {
    pve1 = { cp_ip = "192.168.3.11/24", worker_ip = "192.168.3.21/24", cp_vmid = 8001, worker_vmid = 8101, datastore_id = "vmdata_node1" }
    pve2 = { cp_ip = "192.168.3.12/24", worker_ip = "192.168.3.22/24", cp_vmid = 8002, worker_vmid = 8102, datastore_id = "vmdata_node2" }
    pve3 = { cp_ip = "192.168.3.13/24", worker_ip = "192.168.3.23/24", cp_vmid = 8003, worker_vmid = 8103, datastore_id = "vmdata_node3" }
  }
}

# ------------------------------------------------------------
# SSH
# ------------------------------------------------------------
variable "ssh_public_key_path" {
  description = "Path to the SSH public key file to inject into the VM"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

# ------------------------------------------------------------
# Linux Cloud Image
# ------------------------------------------------------------
variable "linux_cloud_image_url" {
  description = "URL of the Linux cloud image to download"
  type        = string
  default     = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2"
}

variable "linux_cloud_image_filename" {
  description = "Filename to store the cloud image as (must end in .qcow2 for import)"
  type        = string
  default     = "debian-13-genericcloud-amd64.qcow2"
}

variable "image_datastore_id" {
  description = "Proxmox datastore ID to store the downloaded cloud image"
  type        = string
  default     = "local"
}

variable "vm_stop_on_destroy" {
  description = "Force stop the VM on terraform destroy (useful when QEMU agent is not installed)"
  type        = bool
  default     = true
}

variable "vm_agent_enabled" {
  description = "Enable QEMU guest agent (requires qemu-guest-agent installed in the VM)"
  type        = bool
  default     = false
}

# ------------------------------------------------------------
# VM - CPU
# ------------------------------------------------------------
variable "vm_cp_cpu_cores" {
  description = "Number of CPU cores per socket"
  type        = number
  default     = 2
}

variable "vm_wk_cpu_cores" {
  description = "Number of CPU cores per socket"
  type        = number
  default     = 4
}

variable "vm_cpu_sockets" {
  description = "Number of CPU sockets"
  type        = number
  default     = 1
}

variable "vm_cpu_type" {
  description = "CPU type/model (use 'host' for best performance, 'kvm64' for portability)"
  type        = string
  default     = "x86-64-v2-AES"
}

# ------------------------------------------------------------
# VM - Memory
# ------------------------------------------------------------
variable "vm_cp_memory_mb" {
  description = "Amount of dedicated memory in megabytes"
  type        = number
  default     = 4096
}

variable "vm_wk_memory_mb" {
  description = "Amount of dedicated memory in megabytes"
  type        = number
  default     = 8192
}

# ------------------------------------------------------------
# VM - Disk
# ------------------------------------------------------------
variable "vm_cp_disk_size_gb" {
  description = "Size of the primary VM disk in gigabytes"
  type        = number
  default     = 40
}

variable "vm_wk_disk_size_gb" {
  description = "Size of the primary VM disk in gigabytes"
  type        = number
  default     = 60
}

variable "vm_ipv4_gateway" {
  description = "IPv4 default gateway"
  type        = string
  default     = "192.168.3.1"
}

variable "vm_network_bridge" {
  description = "Proxmox network bridge to attach the VM NIC to"
  type        = string
  default     = "vmbr0"
}

variable "vm_network_model" {
  description = "VM NIC model (virtio recommended for best performance)"
  type        = string
  default     = "virtio"
}

variable "vm_network_firewall" {
  description = "Enable Proxmox firewall on the VM NIC"
  type        = bool
  default     = false
}

# ------------------------------------------------------------
# VM - Cloud-Init User
# ------------------------------------------------------------
variable "vm_username" {
  description = "Username to create via cloud-init"
  type        = string
  default     = "test"
}

variable "vm_password" {
  description = "Password for the cloud-init user account"
  type        = string
  sensitive   = true
}

# ------------------------------------------------------------
# RKE2 Bootstrap
# ------------------------------------------------------------

variable "bootstrap_node" {
  description = "Which Proxmox node key hosts the RKE2 cluster-init CP node"
  type        = string
  default     = "core-node-1"
}

variable "rke2_token" {
  description = "Shared secret all nodes use to join the cluster"
  type        = string
  sensitive   = true
}

variable "rke2_version" {
  type    = string
  default = "v1.31.4+rke2r1"
}

variable "cluster_vip" {
  description = "TLS SAN for the API server (VIP/LB address if you add one later)"
  type        = string
  default     = "10.10.10.10"
}
