
variable "index" {
  description = "LB instance"
}

variable "load_balancer" {
  description = "Parent load balancer"
}

variable frontend_ip_config {
  description = "Frontend IP config for each cluster group"
}

variable machines {
  description = "list of machines for this backend pool"
}

variable check_http {
  description = "httpd health probe"
}

variable "network" {
  description = "Network where this LB backend will be attached to"
}

