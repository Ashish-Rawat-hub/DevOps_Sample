provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
  skip_provider_registration = "true"
}

provider "random" {
  
}