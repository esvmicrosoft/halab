

variable "disk_name" {
  description = "defines the name of the disk"
  type        = string
}

variable "region" {
  description = "location of the resource"
  type        = string
}

variable "resource_group" {
  description = "defines the RG of the disk"
  type        = string
}

variable "disk_size" {
  description = "Size of disk"
  default     = false
}

