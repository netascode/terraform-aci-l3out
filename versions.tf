
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aci = {
      source  = "CiscoDevNet/aci"
      version = ">= 2.0.0"
    }
  }

  experiments = [module_variable_optional_attrs]
}
