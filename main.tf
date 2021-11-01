terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm",
      version = "~>2.31.1"
    }
  }
}

provider "azurerm" {
  features {}
}

//Resource group - cqrs-resourcegroup:
resource "azurerm_resource_group" "cqrs-resourcegroup" {
  name     = "cqrs-resourcegroup"
  location = "germanywestcentral"
  tags = {
    source = "terraform"
  }
}

//Service bus namespace - cqrs-servicebus-namespace:
resource "azurerm_servicebus_namespace" "cqrs-servicebus-namespace" {
  name                = "cqrs-servicebus-namespace"
  location            = "germanywestcentral"
  resource_group_name = "cqrs-resourcegroup"
  sku                 = "Standard"

  tags = {
    source = "terraform"
  }
}

//static-data-update-started topic and subscriptions:
resource "azurerm_servicebus_topic" "static-data-update-started" {
  name                = "static-data-update-started"
  resource_group_name = "cqrs-resourcegroup"
  namespace_name      = "cqrs-servicebus-namespace"
}

resource "azurerm_servicebus_subscription" "static-data-notification" {
  name                = "static-data-notification"
  resource_group_name = "cqrs-resourcegroup"
  namespace_name      = "cqrs-servicebus-namespace"
  topic_name          = "static-data-update-started"
  max_delivery_count  = 1
}

resource "azurerm_servicebus_subscription" "taxrules-static-data-notification" {
  name                = "taxrules-static-data-notification"
  resource_group_name = "cqrs-resourcegroup"
  namespace_name      = "cqrs-servicebus-namespace"
  topic_name          = "static-data-update-started"
  max_delivery_count  = 1
}
