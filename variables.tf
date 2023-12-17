
variable "number_of_nodes" {
  description = "Number of nodes in participating cluster"
  type        = string
  default     = "2"
}

variable "prefix" {
  description = "A three character word for personal identification"
}

variable "region" {
  description = "The Azure location where all resources in this example should be created"
}

variable "resource_group_name" {
  description = "Name of the resource group"
}

variable "localip" {
  description = "user's public ip used to grant access via NSG"
}

variable "publisher" {
  description = "image publisher"
}

variable "offer" {
  description = "image offer"
}

variable "sku" {
  description = "image's sku"
}

variable "image_version" {
  description = "image version"
}

variable "cidr_bits" {
  description = "Number of bits dedicated to subnetting"
  type        = string
  default     = "0"
}

variable "hostnames" {
  description = "basename of each host in the HA configuration"
  type        = string
}


#####variable "loginid" {
#####  description = "Azure Fence Agent Application Id"
#####  type = string
#####}
#####
#####variable "pacemaker" {
#####  description = "Azure Fence Agent password"
#####  type = string
#####}
#####
