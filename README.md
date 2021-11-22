#win-vm
##Purpose
This module is used to managed an Azure Windows-based Virtual machine

##Usage
Use this module to manage an Azure Windows-based virtual machine as part of a larger composition.
The Network Interface will be managed by this module too - as such an existing vnet with configured subnets is required up-front

The hostname of the vm is created programatically - the input fields act as constructors, used in the name of the nic, azure object name and vm hostname

###Examples
####Windows 2019 Datacentre VM with two additional 100gb disks
```
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
        environment_short_name = "Jup"
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

}
```

###IMPORTANT - Breaking behaviour
If a disk needs adding to an existing implementation, ensure new disks are added only at the end of the list. Adding a new disk in the middle of the list will result in unnecessary destruction of disks, and just a generally bad time.


##External Dependencies
1. An Azure Resource Group
2. An Azure Virtual Network with:
    a. A configured subnet
3. An existing Key Vault
