# win-vm

## Purpose

This module is used to managed an Azure Windows-based Virtual machine

## Usage

Use this module to manage an Azure Windows-based virtual machine as part of a larger composition.
The Network Interface will be managed by this module too - as such an existing vnet with configured subnets is required up-front

The hostname of the vm is created programatically - the input fields act as constructors, used in the name of the nic, azure object name and vm hostname

Use the `join-domain` boolean to automatically join the PC to the domain.  Username & Password will be stored within `[placeholder]` keyvault. `join-domain` is defaulted to `false` so no need for the variable for non-domain requirements.

### Examples

### Windows 2019 Datacentre VM with two additional 100gb disks

```terraform
module "win-vm" {
    source = "./win-vm"
    resource_group_name = "rg"
    vnet = {
        name = "vnet1"
        resource_group_name = "rg"
    }
    nic_subnet_name = "subnet1"
    key_vault_name = "kv"
    vm_name = {
        service = "dvlpmt"
        environment_letter = "d"
        role = "app"
        vm_number = 1
    }
    virtual_machine_size = "Standard_A1_v2"
    source_image_reference = {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2019-Datacenter"
        version = "latest"
    }
 vm_disks = [
  {
   lun = 10
   storage_account_type = "Standard_LRS"
   disk_size_gb = 100
  },
  {
   lun = 20
   storage_account_type = "Standard_LRS"
   disk_size_gb = 100
  }
 ]
 join-domain = true
}
```

### IMPORTANT - Breaking behaviour

If a disk needs adding to an existing implementation, ensure new disks are added only at the end of the list. Adding a new disk in the middle of the list will result in unnecessary destruction of disks, and just a generally bad time.

## External Dependencies

1. An Azure Resource Group
2. An Azure Virtual Network with:
    a. A configured subnet
3. An existing Key Vault

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=2.44.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >=2.44.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.admin_user](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.admin_user_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_managed_disk.disks](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_virtual_machine_data_disk_attachment.disk-attach](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_extension.join-domain](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_windows_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [random_id.admin_username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [random_password.admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_active_directory_domain"></a> [active\_directory\_domain](#input\_active\_directory\_domain) | Active Directory Name (FQDN) | `string` | `"intra.mps-group.org"` | no |
| <a name="input_active_directory_netbios_domain"></a> [active\_directory\_netbios\_domain](#input\_active\_directory\_netbios\_domain) | Active Directory Net Bios Name | `string` | `"MPSNT"` | no |
| <a name="input_active_directory_password"></a> [active\_directory\_password](#input\_active\_directory\_password) | Password of the admin account used to join the VM to the domain | `string` | `"[password]"` | no |
| <a name="input_active_directory_username"></a> [active\_directory\_username](#input\_active\_directory\_username) | Admin username that is used to join the VM to the domain. | `string` | `"[adminusername]"` | no |
| <a name="input_join_domain"></a> [join\_domain](#input\_join\_domain) | n/a | `bool` | `false` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Name of existing key vault to store the VM admin creds | `string` | n/a | yes |
| <a name="input_nic_subnet_name"></a> [nic\_subnet\_name](#input\_nic\_subnet\_name) | Name of the existing subnet | `string` | n/a | yes |
| <a name="input_os_storage_account_type"></a> [os\_storage\_account\_type](#input\_os\_storage\_account\_type) | Set OS storage account type | `string` | `"StandardSSD_LRS"` | no |
| <a name="input_oupath"></a> [oupath](#input\_oupath) | OU location where the computer object will be created. | `string` | `"OU=Test,OU=Servers,DC=intra,DC=mps-group,DC=org"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the existing resource group | `string` | n/a | yes |
| <a name="input_source_image_reference"></a> [source\_image\_reference](#input\_source\_image\_reference) | A map representing the VM image | <pre>object({<br>    publisher = string<br>    offer     = string<br>    sku       = string<br>    version   = string<br>    }<br>  )</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to identify web app | `map` | n/a | yes |
| <a name="input_virtual_machine_size"></a> [virtual\_machine\_size](#input\_virtual\_machine\_size) | The virtual machine size | `string` | `"Standard_A1_v2"` | no |
| <a name="input_vm_disks"></a> [vm\_disks](#input\_vm\_disks) | A list of disks to add. IMPORTANT - If adding new disks to an existing implementation, ensure that new disks are added at the end. Adding new items in the middle of the list will destroy disks | <pre>list(object({<br>    lun                  = number<br>    storage_account_type = string,<br>    disk_size_gb         = number<br>    }<br>    )<br>  )</pre> | n/a | yes |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | The Virtual name constructor The names of objects are constructed based on these inputs | <pre>object({<br>    service            = string<br>    environment_letter = string<br>    role               = string<br>    vm_number          = number<br>    }<br>  )</pre> | n/a | yes |
| <a name="input_vnet"></a> [vnet](#input\_vnet) | vnet object including the name and resource group | <pre>object(<br>    {<br>      name                = string<br>      resource_group_name = string<br>    }<br>  )</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_virtual_machine_hostname"></a> [virtual\_machine\_hostname](#output\_virtual\_machine\_hostname) | The hostname of the virtual machine |
| <a name="output_virtual_machine_id"></a> [virtual\_machine\_id](#output\_virtual\_machine\_id) | The ID of the managed virtual machine |
| <a name="output_virtual_machine_nic_id"></a> [virtual\_machine\_nic\_id](#output\_virtual\_machine\_nic\_id) | The ID of the network interface of the virtual machine |
| <a name="output_virtual_machine_object_name"></a> [virtual\_machine\_object\_name](#output\_virtual\_machine\_object\_name) | The Azure object name of the virtual machine |
| <a name="output_vm_admin_password"></a> [vm\_admin\_password](#output\_vm\_admin\_password) | The local administrator account password |
| <a name="output_vm_admin_username"></a> [vm\_admin\_username](#output\_vm\_admin\_username) | The local Administrator account username |
<!-- END_TF_DOCS -->