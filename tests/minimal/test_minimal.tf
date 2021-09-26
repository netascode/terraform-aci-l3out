terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    aci = {
      source  = "netascode/aci"
      version = ">=0.2.0"
    }
  }
}

resource "aci_rest" "fvTenant" {
  dn         = "uni/tn-TF"
  class_name = "fvTenant"
}

module "main" {
  source = "../.."

  tenant        = "TF"
  name          = "L3OUT1"
  routed_domain = "RD1"
  vrf           = "VRF1"
}

data "aci_rest" "l3extOut" {
  dn = module.main.dn

  depends_on = [module.main]
}

resource "test_assertions" "l3extOut" {
  component = "l3extOut"

  equal "name" {
    description = "name"
    got         = data.aci_rest.l3extOut.content.name
    want        = module.main.name
  }
}

data "aci_rest" "l3extRsL3DomAtt" {
  dn = "${data.aci_rest.l3extOut.id}/rsl3DomAtt"

  depends_on = [module.main]
}

resource "test_assertions" "l3extRsL3DomAtt" {
  component = "l3extRsL3DomAtt"

  equal "tDn" {
    description = "tDn"
    got         = data.aci_rest.l3extRsL3DomAtt.content.tDn
    want        = "uni/l3dom-RD1"
  }
}

data "aci_rest" "l3extRsEctx" {
  dn = "${data.aci_rest.l3extOut.id}/rsectx"

  depends_on = [module.main]
}

resource "test_assertions" "l3extRsEctx" {
  component = "l3extRsEctx"

  equal "tnFvCtxName" {
    description = "tnFvCtxName"
    got         = data.aci_rest.l3extRsEctx.content.tnFvCtxName
    want        = "VRF1"
  }
}
