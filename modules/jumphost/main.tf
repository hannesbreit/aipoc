resource "azurerm_resource_group" "this" {
  name     = "rg-${var.prefix}-${var.stage}-${local.country_code}"
  location = var.location
  lifecycle {
    ignore_changes = [
      tags,
    ]

  }
}

resource "azurerm_network_interface" "this" {
  name                = "nic-${var.prefix}-${var.stage}-${local.country_code}"
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  ip_configuration {
    name                          = "ipconfig-${var.prefix}-${var.stage}-${local.country_code}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  lifecycle {
    ignore_changes = [
      tags
    ]

  }
}

resource "random_password" "this" {
  length      = 20
  upper       = true
  min_lower   = 2
  min_numeric = 2
  min_special = 2
  min_upper   = 2
  lower       = true
  numeric     = true
  special     = true

}

resource "azurerm_key_vault_secret" "this" {
  name         = "adminuser"
  value        = random_password.this.result
  key_vault_id = var.key_vault_id
}

resource "azurerm_windows_virtual_machine" "this" {
  name                       = "vm-${var.prefix}-${var.stage}-${local.country_code}"
  computer_name              = replace("${var.prefix}", "-", "")
  location                   = azurerm_resource_group.this.location
  resource_group_name        = azurerm_resource_group.this.name
  network_interface_ids      = [azurerm_network_interface.this.id]
  size                       = var.sizing
  admin_username             = "adminuser"
  admin_password             = random_password.this.result
  encryption_at_host_enabled = true

  os_disk {
    name                 = "osdisk-${var.prefix}-${var.stage}-${local.country_code}"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }

  provision_vm_agent       = true
  enable_automatic_updates = true

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}
