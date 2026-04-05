# ---------------------------------------------------------------------------
# variables.tf — Option 1 (dedicated terraform Linux user)
# ---------------------------------------------------------------------------

# ── Proxmox connection ──────────────────────────────────────────────────────

variable "proxmox_endpoint" {
  description = "Proxmox API URL, e.g. https://192.168.1.10:8006/"
  type        = string
}

variable "proxmox_api_token" {
  description = "API token: terraform@pve!mytoken=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Skip TLS verification (true for self-signed certs)"
  type        = bool
  default     = false
}

variable "proxmox_node" {
  description = "Proxmox node name as shown in the UI"
  type        = string
  default     = "pve"
}

variable "proxmox_nodes" {
  description = "List of Proxmox node names to attach storage to"
  type        = list(string)
}

# ── Storage ──────────────────────────────────────────────────────────────────

variable "image_datastore" {
  description = "Datastore for the cloud image (must have ISO content type enabled)"
  type        = string
  default     = "local"
}

variable "vm_datastore" {
  description = "Datastore for VM disks and cloud-init drive"
  type        = string
  default     = "local-lvm"
}

# ── Cloud image ───────────────────────────────────────────────────────────────

variable "debian13_image_url" {
  description = "Direct URL to the Debian 13 genericcloud qcow2 image"
  type        = string
  default     = "https://cloud.debian.org/images/cloud/trixie/daily/latest/debian-13-genericcloud-amd64-daily.qcow2"
}

# ── VM identity ───────────────────────────────────────────────────────────────

variable "vm_id" {
  type    = number
  default = 200
}

variable "vm_name" {
  type    = string
  default = "debian13-cloud"
}

variable "start_on_boot" {
  type    = bool
  default = false
}

# ── Hardware ──────────────────────────────────────────────────────────────────

variable "cpu_cores" {
  type    = number
  default = 2
}

variable "memory_mb" {
  type    = number
  default = 2048
}

variable "disk_size_gb" {
  type    = number
  default = 20
}

# ── Network ───────────────────────────────────────────────────────────────────

variable "network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "ip_address" {
  description = "IPv4 in CIDR notation (192.168.1.100/24) or \"dhcp\""
  type        = string
  default     = "dhcp"
}

variable "gateway" {
  type    = string
  default = ""
}

variable "dns_servers" {
  type    = list(string)
  default = ["1.1.1.1", "8.8.8.8"]
}

variable "dns_search_domain" {
  type    = string
  default = ""
}

# ── Cloud-Init ────────────────────────────────────────────────────────────────

variable "cloud_init_user" {
  type    = string
  default = "debian"
}

variable "cloud_init_password" {
  type      = string
  sensitive = true
  default   = ""
}

variable "ssh_public_keys" {
  description = "SSH public keys for the VM's default user"
  type        = list(string)
  default     = []
}

variable "nas_ip" {
  description = "NAS IP Address"
  type        = string
}

variable "nfs_shares" {
  description = "List of NFS shares to add to Proxmox"
  type = list(object({
    id      = string
    export  = string
    content = list(string)
  }))
}
