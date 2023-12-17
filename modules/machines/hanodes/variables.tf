

variable "server_name" {
  description = "defines the name of the machine to use"
  type        = string
}


variable "resource_group" {
  description = "defines the RG of the machine to use"
}

variable "cidr_bits" {
  description = "Number of bits added to the netmask"
  type        = string
}

variable "storage_account" {
  description = "Diagnostics Storage Account"
  type        = string
}

variable "host_instance" {
  description = "Diagnostics Storage Account"
  type        = number
}

variable "subnets_cidrs" {
  description = "List of available subnet cidrs available on the vnet"
  type        = list
}

variable "subnets_ids" {
  description = "List of available subnet cidrs available on the vnet"
  type        = list
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

variable "avsetid" {
  description = "availability set id"
}

variable "rsakey" {
  description = "SSH keys for azureuser and root"
}
