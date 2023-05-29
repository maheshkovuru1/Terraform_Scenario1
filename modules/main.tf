# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.46.0"
    }
  }
}

#https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret
provider "azurerm" {
  features {}
}




#create resource group
resource "azurerm_resource_group" "rg" {
  name     = var.rgname
  location = var.rglocation
  tags = {
    Environment = "Terraform Demo"
  }
}

locals {
  rg_info = resource.azurerm_resource_group.rg
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "${var.prefix}-10"
  resource_group_name = local.rg_info.name
  location            = local.rg_info.location
  address_space       = ["${var.vnet_cidr_prefix}"]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "var.subnet"
  virtual_network_name = azurerm_virtual_network.vnet1.name
  resource_group_name  = local.rg_info.name
  address_prefixes     = ["${var.subnet1_cidr_prefix}"]
}

resource "azurerm_network_security_group" "nsg1" {
  name                = "${var.prefix}-nsg1"
  resource_group_name = local.rg_info.name
  location            = local.rg_info.location
}

resource "azurerm_network_interface" "nic" {
  count               = 2
  name                = "${var.prefix}-NIC-${count.index}"
  resource_group_name = local.rg_info.name
  location            = local.rg_info.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
  }
}
