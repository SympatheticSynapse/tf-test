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
  description = "Proxmox node to place the Vault VM on. Keep it off the node carrying your primary storage/PBS role, same as Forgejo."
  type        = string
}

variable "vm_id" {
  type    = number
  default = 8200
}

variable "vm_name" {
  type    = string
  default = "vault"
}

variable "disk_datastore" {
  description = "Per-node VM data datastore, e.g. vmdata-node2"
  type        = string
}

variable "snippet_datastore" {
  description = "Datastore with 'Snippets' content type enabled"
  type        = string
  default     = "local"
}

variable "image_datastore_id" {
  type    = string
  default = "local"
}

variable "linux_cloud_image_url" {
  type    = string
  default = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2"
}

variable "linux_cloud_image_filename" {
  type    = string
  default = "debian-13-genericcloud-amd64.qcow2"
}

variable "disk_size_gb" {
  description = "Root disk size. Vault's raft storage lives here - modest for a single-instance homelab setup."
  type        = number
  default     = 16
}

variable "cores" {
  type    = number
  default = 2
}

variable "memory_mb" {
  type    = number
  default = 4096
}

variable "network_bridge" {
  type    = string
  default = "vmbr0"
}

variable "ip_address_cidr" {
  type = string
}

variable "gateway" {
  type = string
}

variable "dns_servers" {
  type    = list(string)
  default = ["10.0.10.1"]
}

variable "ssh_public_key_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "ci_user_password_hash" {
  description = "SHA-512 crypt hash for console fallback access (generate with: openssl passwd -6)"
  type        = string
  sensitive   = true
}

variable "vault_version" {
  description = "Vault release to install (check https://releases.hashicorp.com/vault for current)"
  type        = string
  default     = "2.0.3"
}

variable "vault_domain" {
  description = "DNS name Vault will be reached at - used for the TLS cert SAN and api_addr/cluster_addr"
  type        = string
  default     = "vault.corehomelab.net"
}
