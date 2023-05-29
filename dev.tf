/*terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.46.0"
    }
  }
}*/

terraform {
  backend "azurerm" {
    storage_account_name = "mktfstorage"
    container_name       = "tfstate-modules"
    key                  = "prod.terraform.tfstate"

    # rather than defining this inline, the Access Key can also be sourced
    # from an Environment Variable - more information is available below.
    access_key = "f4W0O7E7+UbZQTEyiJUacoz9eToYzmOw1encUXlBanfFY26JrXWKl8CLDvalvtNtrywQ2z5k9Z1e+AStZbm0fQ=="
  }
}

module "module_dev" {
    source = "./modules"
    prefix = "dev"
    vnet_cidr_prefix = "10.20.0.0/16"
    subnet1_cidr_prefix = "10.20.1.0/24"
    rgname = "DevRG"
    subnet = "DevSubnet"
}
