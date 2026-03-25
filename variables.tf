# ─── Proxmox Provider ───────────────────────────────────────────────────────

variable "proxmox_endpoint" {
  description = "URL of the Proxmox API endpoint (e.g. https://192.168.1.10:8006/)"
  type        = string
}

variable "proxmox_api_token" {
  description = "Proxmox API token in the format 'USER@REALM!TOKENID=SECRET'"
  type        = string
  sensitive   = true
}

variable "proxmox_insecure" {
  description = "Skip TLS certificate verification (set true for self-signed certs)"
  type        = bool
  default     = false
}

variable "proxmox_node" {
  description = "Proxmox node name to deploy the container on"
  type        = string
  default     = "pve"
}

# ─── Container Identity ──────────────────────────────────────────────────────

variable "container_id" {
  description = "Unique VM/CT ID for the container (100–999999999)"
  type        = number
  default     = 200
}

variable "container_hostname" {
  description = "Hostname of the LXC container"
  type        = string
  default     = "debian13-lxc"
}

# ─── Template ────────────────────────────────────────────────────────────────

variable "template_file_id" {
  description = <<-EOT
    Proxmox file ID of the Debian 13 container template.
    Format: '<datastore>:vztmpl/<template-filename>'
    Example: 'local:vztmpl/debian-13-standard_13.0-1_amd64.tar.zst'
  EOT
  type        = string
  default     = "local:vztmpl/debian-13-standard_13.0-1_amd64.tar.zst"
}

# ─── Resources ───────────────────────────────────────────────────────────────

variable "cpu_cores" {
  description = "Number of CPU cores allocated to the container"
  type        = number
  default     = 2
}

variable "memory_mb" {
  description = "Amount of RAM in megabytes"
  type        = number
  default     = 512
}

variable "swap_mb" {
  description = "Amount of swap space in megabytes"
  type        = number
  default     = 512
}

variable "disk_size_gb" {
  description = "Root disk size in gigabytes"
  type        = number
  default     = 8
}

variable "storage_datastore" {
  description = "Proxmox datastore ID for the container's root disk (e.g. 'local-lvm', 'local-zfs')"
  type        = string
  default     = "local-lvm"
}

# ─── Networking ───────────────────────────────────────────────────────────────

variable "network_bridge" {
  description = "Linux bridge to attach the container's network interface to"
  type        = string
  default     = "vmbr0"
}

# ─── Features ─────────────────────────────────────────────────────────────────

variable "enable_nesting" {
  description = "Enable container nesting (required for running Docker inside LXC)"
  type        = bool
  default     = false
}

# ─── Root ─────────────────────────────────────────────────────────────────────

variable "root_password" {
  description = "Root password for the container"
  type        = string
  sensitive   = true
  # no default = Terraform will prompt you
}
