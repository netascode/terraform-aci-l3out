<!-- BEGIN_TF_DOCS -->
# L3out Example

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example will create resources. Resources can be destroyed with `terraform destroy`.

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
<!-- END_TF_DOCS -->