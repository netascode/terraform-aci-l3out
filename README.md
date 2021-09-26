<!-- BEGIN_TF_DOCS -->
[![Tests](https://github.com/netascode/terraform-aci-l3out/actions/workflows/test.yml/badge.svg)](https://github.com/netascode/terraform-aci-l3out/actions/workflows/test.yml)

# Terraform ACI L3out Module

Manages ACI L3out

Location in GUI:
`Tenants` » `XXX` » `Networking` » `L3outs`

## Examples

```hcl
module "aci_l3out" {
  source  = "netascode/l3out/aci"
  version = ">= 0.0.1"

  tenant                       = "ABC"
  name                         = "L3OUT1"
  alias                        = "L3OUT1-ALIAS"
  description                  = "My Description"
  routed_domain                = "RD1"
  vrf                          = "VRF1"
  bgp                          = true
  ospf                         = true
  ospf_area                    = "0.0.0.10"
  ospf_area_cost               = 10
  ospf_area_type               = "stub"
  import_route_map_description = "IRM Description"
  import_route_map_type        = "global"
  import_route_map_contexts = [{
    name        = "ICON1"
    description = "ICON1 Description"
    action      = "deny"
    order       = 5
    set_rule    = "ISET1"
    match_rule  = "IMATCH1"
  }]
  export_route_map_description = "ERM Description"
  export_route_map_type        = "global"
  export_route_map_contexts = [{
    name        = "ECON1"
    description = "ECON1 Description"
    action      = "deny"
    order       = 6
    set_rule    = "ESET1"
    match_rule  = "EMATCH1"
  }]
}

```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aci"></a> [aci](#requirement\_aci) | >= 0.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aci"></a> [aci](#provider\_aci) | >= 0.2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_tenant"></a> [tenant](#input\_tenant) | Tenant name. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | L3out name. | `string` | n/a | yes |
| <a name="input_alias"></a> [alias](#input\_alias) | Alias. | `string` | `""` | no |
| <a name="input_description"></a> [description](#input\_description) | Description. | `string` | `""` | no |
| <a name="input_routed_domain"></a> [routed\_domain](#input\_routed\_domain) | Routed domain name. | `string` | n/a | yes |
| <a name="input_vrf"></a> [vrf](#input\_vrf) | VRF name. | `string` | n/a | yes |
| <a name="input_ospf"></a> [ospf](#input\_ospf) | Enable OSPF routing. | `bool` | `false` | no |
| <a name="input_bgp"></a> [bgp](#input\_bgp) | Enable BGP routing. | `bool` | `false` | no |
| <a name="input_ospf_area"></a> [ospf\_area](#input\_ospf\_area) | OSPF area. Allowed values are `backbone` or a number between 1 and 4294967295. | `string` | `"backbone"` | no |
| <a name="input_ospf_area_cost"></a> [ospf\_area\_cost](#input\_ospf\_area\_cost) | OSPF area cost. Minimum value: 1. Maximum value: 16777215. | `number` | `1` | no |
| <a name="input_ospf_area_type"></a> [ospf\_area\_type](#input\_ospf\_area\_type) | OSPF area type. Choices: `regular`, `stub`, `nssa`. | `string` | `"regular"` | no |
| <a name="input_import_route_map_description"></a> [import\_route\_map\_description](#input\_import\_route\_map\_description) | Import route map description. | `string` | `""` | no |
| <a name="input_import_route_map_type"></a> [import\_route\_map\_type](#input\_import\_route\_map\_type) | Import route map type. Choices: `combinable`, `global`. | `string` | `"combinable"` | no |
| <a name="input_import_route_map_contexts"></a> [import\_route\_map\_contexts](#input\_import\_route\_map\_contexts) | List of import route map contexts. Choices `action`: `permit`, `deny`. Default value `action`: `permit`. Allowed values `order`: 0-9. Default value `order`: 0. | <pre>list(object({<br>    name        = string<br>    description = optional(string)<br>    action      = optional(string)<br>    order       = optional(number)<br>    set_rule    = optional(string)<br>    match_rule  = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_export_route_map_description"></a> [export\_route\_map\_description](#input\_export\_route\_map\_description) | Import route map description. | `string` | `""` | no |
| <a name="input_export_route_map_type"></a> [export\_route\_map\_type](#input\_export\_route\_map\_type) | Import route map type. Choices: `combinable`, `global`. | `string` | `"combinable"` | no |
| <a name="input_export_route_map_contexts"></a> [export\_route\_map\_contexts](#input\_export\_route\_map\_contexts) | List of export route map contexts. Choices `action`: `permit`, `deny`. Default value `action`: `permit`. Allowed values `order`: 0-9. Default value `order`: 0. | <pre>list(object({<br>    name        = string<br>    description = optional(string)<br>    action      = optional(string)<br>    order       = optional(number)<br>    set_rule    = optional(string)<br>    match_rule  = optional(string)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dn"></a> [dn](#output\_dn) | Distinguished name of `l3extOut` object. |
| <a name="output_name"></a> [name](#output\_name) | L3out name. |

## Resources

| Name | Type |
|------|------|
| [aci_rest.bgpExtP](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.l3extOut](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.l3extRsEctx](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.l3extRsL3DomAtt](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.ospfExtP](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.rtctrlCtxP_export](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.rtctrlCtxP_import](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.rtctrlProfile_export](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.rtctrlProfile_import](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.rtctrlRsCtxPToSubjP_export](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.rtctrlRsCtxPToSubjP_import](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.rtctrlRsScopeToAttrP_export](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.rtctrlRsScopeToAttrP_import](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.rtctrlScope_export](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
| [aci_rest.rtctrlScope_import](https://registry.terraform.io/providers/netascode/aci/latest/docs/resources/rest) | resource |
<!-- END_TF_DOCS -->