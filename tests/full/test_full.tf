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

  tenant                       = "TF"
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

  equal "descr" {
    description = "descr"
    got         = data.aci_rest.l3extOut.content.descr
    want        = "My Description"
  }

  equal "nameAlias" {
    description = "nameAlias"
    got         = data.aci_rest.l3extOut.content.nameAlias
    want        = "L3OUT1-ALIAS"
  }
}

data "aci_rest" "ospfExtP" {
  dn = "${data.aci_rest.l3extOut.id}/ospfExtP"

  depends_on = [module.main]
}

resource "test_assertions" "ospfExtP" {
  component = "ospfExtP"

  equal "areaCost" {
    description = "areaCost"
    got         = data.aci_rest.ospfExtP.content.areaCost
    want        = "10"
  }

  equal "areaCtrl" {
    description = "areaCtrl"
    got         = data.aci_rest.ospfExtP.content.areaCtrl
    want        = "redistribute,summary"
  }

  equal "areaId" {
    description = "areaId"
    got         = data.aci_rest.ospfExtP.content.areaId
    want        = "0.0.0.10"
  }

  equal "areaType" {
    description = "areaType"
    got         = data.aci_rest.ospfExtP.content.areaType
    want        = "stub"
  }
}

data "aci_rest" "bgpExtP" {
  dn = "${data.aci_rest.l3extOut.id}/bgpExtP"

  depends_on = [module.main]
}

resource "test_assertions" "bgpExtP" {
  component = "bgpExtP"

  equal "name" {
    description = "name"
    got         = data.aci_rest.bgpExtP.content.name
    want        = "bgp"
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

data "aci_rest" "rtctrlProfile_import" {
  dn = "${data.aci_rest.l3extOut.id}/prof-default-import"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlProfile_import" {
  component = "rtctrlProfile_import"

  equal "name" {
    description = "name"
    got         = data.aci_rest.rtctrlProfile_import.content.name
    want        = "default-import"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest.rtctrlProfile_import.content.descr
    want        = "IRM Description"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest.rtctrlProfile_import.content.type
    want        = "global"
  }
}

data "aci_rest" "rtctrlCtxP_import" {
  dn = "${data.aci_rest.rtctrlProfile_import.id}/ctx-ICON1"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlCtxP_import" {
  component = "rtctrlCtxP_import"

  equal "name" {
    description = "name"
    got         = data.aci_rest.rtctrlCtxP_import.content.name
    want        = "ICON1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest.rtctrlCtxP_import.content.descr
    want        = "ICON1 Description"
  }

  equal "action" {
    description = "action"
    got         = data.aci_rest.rtctrlCtxP_import.content.action
    want        = "deny"
  }

  equal "order" {
    description = "order"
    got         = data.aci_rest.rtctrlCtxP_import.content.order
    want        = "5"
  }
}

data "aci_rest" "rtctrlRsScopeToAttrP_import" {
  dn = "${data.aci_rest.rtctrlCtxP_import.id}/scp/rsScopeToAttrP"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlRsScopeToAttrP_import" {
  component = "rtctrlRsScopeToAttrP_import"

  equal "tnRtctrlAttrPName" {
    description = "tnRtctrlAttrPName"
    got         = data.aci_rest.rtctrlRsScopeToAttrP_import.content.tnRtctrlAttrPName
    want        = "ISET1"
  }
}

data "aci_rest" "rtctrlRsCtxPToSubjP_import" {
  dn = "${data.aci_rest.rtctrlCtxP_import.id}/rsctxPToSubjP-IMATCH1"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlRsCtxPToSubjP_import" {
  component = "rtctrlRsCtxPToSubjP_import"

  equal "tnRtctrlSubjPName" {
    description = "tnRtctrlSubjPName"
    got         = data.aci_rest.rtctrlRsCtxPToSubjP_import.content.tnRtctrlSubjPName
    want        = "IMATCH1"
  }
}

data "aci_rest" "rtctrlProfile_export" {
  dn = "${data.aci_rest.l3extOut.id}/prof-default-export"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlProfile_export" {
  component = "rtctrlProfile_export"

  equal "name" {
    description = "name"
    got         = data.aci_rest.rtctrlProfile_export.content.name
    want        = "default-export"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest.rtctrlProfile_export.content.descr
    want        = "ERM Description"
  }

  equal "type" {
    description = "type"
    got         = data.aci_rest.rtctrlProfile_export.content.type
    want        = "global"
  }
}

data "aci_rest" "rtctrlCtxP_export" {
  dn = "${data.aci_rest.rtctrlProfile_export.id}/ctx-ECON1"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlCtxP_export" {
  component = "rtctrlCtxP_export"

  equal "name" {
    description = "name"
    got         = data.aci_rest.rtctrlCtxP_export.content.name
    want        = "ECON1"
  }

  equal "descr" {
    description = "descr"
    got         = data.aci_rest.rtctrlCtxP_export.content.descr
    want        = "ECON1 Description"
  }

  equal "action" {
    description = "action"
    got         = data.aci_rest.rtctrlCtxP_export.content.action
    want        = "deny"
  }

  equal "order" {
    description = "order"
    got         = data.aci_rest.rtctrlCtxP_export.content.order
    want        = "6"
  }
}

data "aci_rest" "rtctrlRsScopeToAttrP_export" {
  dn = "${data.aci_rest.rtctrlCtxP_export.id}/scp/rsScopeToAttrP"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlRsScopeToAttrP_export" {
  component = "rtctrlRsScopeToAttrP_export"

  equal "tnRtctrlAttrPName" {
    description = "tnRtctrlAttrPName"
    got         = data.aci_rest.rtctrlRsScopeToAttrP_export.content.tnRtctrlAttrPName
    want        = "ESET1"
  }
}

data "aci_rest" "rtctrlRsCtxPToSubjP_export" {
  dn = "${data.aci_rest.rtctrlCtxP_export.id}/rsctxPToSubjP-EMATCH1"

  depends_on = [module.main]
}

resource "test_assertions" "rtctrlRsCtxPToSubjP_export" {
  component = "rtctrlRsCtxPToSubjP_export"

  equal "tnRtctrlSubjPName" {
    description = "tnRtctrlSubjPName"
    got         = data.aci_rest.rtctrlRsCtxPToSubjP_export.content.tnRtctrlSubjPName
    want        = "EMATCH1"
  }
}
