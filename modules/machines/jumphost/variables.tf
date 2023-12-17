

variable "server_name" {
  description = "defines the name of the machine to use"
  type        = string
}

variable "resource_group" {
  description = "defines the RG of the machine to use"
}

variable "nic0_ip" {
  description = "NIC IP address"
  type        = string
}


variable "nic0_subnetid" {
  description = "NICs subnet ID"
  type        = string
}

variable "pubip" {
  description = "Assign public ip or not"
  default     = false
}

variable "storage_account" {
  description = "Diagnostics Storage Account"
  default     = false
}

variable "vaultname" {
  description = "Azure keyvault used to deploy the Lab"
}

variable "publisher" { 
  description = "Image Publisher"
}

variable "offer" { 
  description = "machine's offer"
}

variable "sku" { 
  description = "SKU Publisher"
}

variable "image_version" { 
  description = "Image Version"
}

#variable "machines" {
#  description = "List of HA nodes to use in the cluster" 
#}

variable "rsakey" {
  description = "SSH keys for azureuser and root"
}

