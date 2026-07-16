# ------------------------------------------------------------
# NFS Storage
# ------------------------------------------------------------
variable "nas_ip" {
  description = "IP address of the NAS / NFS server"
  type        = string
}

variable "nfs_shares" {
  description = "List of NFS share definitions to add as Proxmox storage"
  type = list(object({
    id      = string
    export  = string
    content = list(string)
  }))
  default = []
}

variable "nfs_options" {
  description = "NFS mount options string"
  type        = string
  default     = "vers=3"
}
