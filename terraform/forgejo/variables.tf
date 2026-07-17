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

variable "proxmox_node" {
  description = "Proxmox node to place the Forgejo VM on. Pick a node other than the one carrying your primary HDD pool / PBS target."
  type        = string
  default     = "node2"
}

variable "vm_id" {
  description = "Proxmox VMID for the Forgejo VM"
  type        = number
  default     = 8100
}

variable "vm_name" {
  type    = string
  default = "forgejo"
}

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

variable "disk_datastore" {
  description = "Per-node VM data datastore, e.g. vmdata-node2"
  type        = string
  default     = "vmdata-node2"
}

variable "snippet_datastore" {
  description = "Datastore that has 'snippets' content enabled, used to hold the cloud-init user-data file"
  type        = string
  default     = "local"
}

variable "disk_size_gb" {
  description = "Root/data disk size. Repo + registry + actions artifacts data lives here."
  type        = number
  default     = 120
}

variable "cores" {
  type    = number
  default = 4
}

variable "memory_mb" {
  type    = number
  default = 8192
}

variable "network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "ip_address_cidr" {
  description = "Static IP/CIDR for the Forgejo VM, e.g. 10.0.10.20/24"
  type        = string
}

variable "gateway" {
  type = string
}

variable "dns_servers" {
  type    = list(string)
  default = ["10.0.10.1"]
}

# ------------------------------------------------------------
# SSH
# ------------------------------------------------------------
variable "ssh_public_key_path" {
  description = "Path to the SSH public key file to inject into the VM"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "ci_user_password_hash" {
  description = "SHA-512 crypt hash for the 'forgejo' cloud-init user (generate with: openssl passwd -6). Key-based auth is still preferred; this is a fallback for console access."
  type        = string
  sensitive   = true
}

variable "forgejo_db_password" {
  description = "Password for the 'forgejo' Postgres role/database, injected into the compose file"
  type        = string
  sensitive   = true
}
