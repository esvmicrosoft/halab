## Terraform Provider Configuration

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }

}

## Terraform Azure Provider

provider "azurerm" {
  features {}
}
