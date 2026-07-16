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

variable "template_vm_id" {
  description = "VMID of the Debian 13 genericcloud template to clone (same template used for the K8s VMs)"
  type        = number
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

variable "ssh_public_keys" {
  description = "SSH public keys authorized on the VM"
  type        = list(string)
}

variable "ci_user_password_hash" {
  description = "SHA-512 crypt hash for the 'forgejo' cloud-init user (generate with: openssl passwd -6). Key-based auth is still preferred; this is a fallback for console access."
  type        = string
  sensitive   = true
}
