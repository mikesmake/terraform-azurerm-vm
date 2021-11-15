#Existing resource group name
variable "resource_group_name" {
  type        = string
  description = "Name of the existing resource group"
}

#Existing vnet
variable "vnet" {
  type = object(
    {
      name                = string
      resource_group_name = string
    }
  )

  description = "vnet object including the name and resource group"
}

#Existing subnet name
variable "nic_subnet_name" {
  type        = string
  description = "Name of the existing subnet"
}

#Existing key vault (to store vm admin creds)
variable "key_vault_name" {
  type        = string
  description = "Name of existing key vault to store the VM admin creds"
}

#The Virtual name constructor
#The names of objects are constructed based on these inputs
variable "vm_name" {

  type = object({
    service            = string
    environment_letter = string
    role               = string
    vm_number          = number
    }
  )

  validation {
    condition = (
      length(var.vm_name["environment_letter"]) == 1 &&
      length(regexall("[LlTtDdUu]", var.vm_name["environment_letter"])) > 0
    )
    error_message = "The environment character must be one character from L T D U."
  }

  validation {
    condition = (
      (contains(["web", "app", "sql"], lower(var.vm_name["role"])))
    )
    error_message = "Role must be one of web app sql."
  }

  validation {
    condition = (
      lower(var.vm_name["service"]) == "onemps" ||
      upper(var.vm_name["service"]) == "DWH" ||
      lower(var.vm_name["service"]) == "dvlpmt" ||
      lower(var.vm_name["service"]) == "portal" ||
      upper(var.vm_name["service"]) == "JKO"
    )
    error_message = "Service must be one of OneMPS / dvlpmt."
  }

  validation {
    condition = (
      var.vm_name["vm_number"] > 0 &&
      var.vm_name["vm_number"] < 100
    )
    error_message = "Vm_Number must be a number above 0 and below 100."
  }
}



#See https://docs.microsoft.com/en-gb/azure/virtual-machines/sizes for more details
variable "virtual_machine_size" {
  type        = string
  default     = "Standard_A1_v2"
  description = "The virtual machine size"
}

#See https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage
variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
    }
  )
  description = "A map representing the VM image"
}

#A list of disks to add. IMPORTANT - If adding new disks to an existing implementation, ensure that new disks are added at the end. Adding new items in the middle of the list will destroy disks
variable "vm_disks" {
  type = list(object({
    lun                  = number
    storage_account_type = string,
    disk_size_gb         = number
    }
    )
  )

}

#Set OS storage account type
variable "os_storage_account_type" {
  type        = string
  description = "Set OS storage account type"
  default     = "StandardSSD_LRS"
}

variable "active_directory_domain" {
  type        = string
  description = "Active Directory Name (FQDN)"
  default     = "intra.mps-group.org"
}

variable "active_directory_netbios_domain" {
  type        = string
  description = "Active Directory Net Bios Name"
  default     = "MPSNT"
}

variable "oupath" {
  type        = string
  description = "OU location where the computer object will be created."
  default     = "OU=Test,OU=Servers,DC=intra,DC=mps-group,DC=org"
}

variable "active_directory_username" {
  type        = string
  description = "Admin username that is used to join the VM to the domain."
  default     = "nobody"
}

variable "active_directory_password" {
  type        = string
  sensitive   = true
  description = "Password of the admin account used to join the VM to the domain"
  default     = "ReplaceInASecureWay"
}

variable "join_domain" {
  type    = bool
  default = false

}

variable "tags" {
  type        = map(any)
  description = "Tags to identify web app"
}