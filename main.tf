resource "aci_rest" "l3extOut" {
  dn         = "uni/tn-${var.tenant}/out-${var.name}"
  class_name = "l3extOut"
  content = {
    name      = var.name
    descr     = var.description
    nameAlias = var.alias
  }
}

resource "aci_rest" "ospfExtP" {
  count      = var.ospf == true ? 1 : 0
  dn         = "${aci_rest.l3extOut.dn}/ospfExtP"
  class_name = "ospfExtP"
  content = {
    areaCost = var.ospf_area_cost
    areaCtrl = "redistribute,summary"
    areaId   = var.ospf_area
    areaType = var.ospf_area_type
  }
}

resource "aci_rest" "bgpExtP" {
  count      = var.tenant == "infra" || var.bgp == true ? 1 : 0
  dn         = "${aci_rest.l3extOut.dn}/bgpExtP"
  class_name = "bgpExtP"
}

resource "aci_rest" "l3extRsL3DomAtt" {
  dn         = "${aci_rest.l3extOut.dn}/rsl3DomAtt"
  class_name = "l3extRsL3DomAtt"
  content = {
    tDn = "uni/l3dom-${var.routed_domain}"
  }
}

resource "aci_rest" "l3extRsEctx" {
  dn         = "${aci_rest.l3extOut.dn}/rsectx"
  class_name = "l3extRsEctx"
  content = {
    tnFvCtxName = var.vrf
  }
}

resource "aci_rest" "rtctrlProfile_import" {
  count      = var.import_route_map_contexts != [] ? 1 : 0
  dn         = "${aci_rest.l3extOut.dn}/prof-default-import"
  class_name = "rtctrlProfile"
  content = {
    name  = "default-import"
    descr = var.import_route_map_description
    type  = var.import_route_map_type
  }
}

resource "aci_rest" "rtctrlCtxP_import" {
  for_each   = { for context in var.import_route_map_contexts : context.name => context }
  dn         = "${aci_rest.rtctrlProfile_import[0].dn}/ctx-${each.value.name}"
  class_name = "rtctrlCtxP"
  content = {
    name   = each.value.name
    descr  = each.value.description != null ? each.value.description : ""
    action = each.value.action != null ? each.value.action : "permit"
    order  = each.value.order != null ? each.value.order : "0"
  }
}

resource "aci_rest" "rtctrlScope_import" {
  for_each   = { for context in var.import_route_map_contexts : context.name => context if context.set_rule != null && context.set_rule != "" }
  dn         = "${aci_rest.rtctrlCtxP_import[each.value.name].dn}/scp"
  class_name = "rtctrlScope"
}

resource "aci_rest" "rtctrlRsScopeToAttrP_import" {
  for_each   = { for context in var.import_route_map_contexts : context.name => context if context.set_rule != null && context.set_rule != "" }
  dn         = "${aci_rest.rtctrlScope_import[each.value.name].dn}/rsScopeToAttrP"
  class_name = "rtctrlRsScopeToAttrP"
  content = {
    tnRtctrlAttrPName = each.value.set_rule
  }
}

resource "aci_rest" "rtctrlRsCtxPToSubjP_import" {
  for_each   = { for context in var.import_route_map_contexts : context.name => context if context.match_rule != null && context.match_rule != "" }
  dn         = "${aci_rest.rtctrlCtxP_import[each.value.name].dn}/rsctxPToSubjP-${each.value.match_rule}"
  class_name = "rtctrlRsCtxPToSubjP"
  content = {
    tnRtctrlSubjPName = each.value.match_rule
  }
}

resource "aci_rest" "rtctrlProfile_export" {
  count      = var.export_route_map_contexts != [] ? 1 : 0
  dn         = "${aci_rest.l3extOut.dn}/prof-default-export"
  class_name = "rtctrlProfile"
  content = {
    name  = "default-export"
    descr = var.export_route_map_description
    type  = var.export_route_map_type
  }
}

resource "aci_rest" "rtctrlCtxP_export" {
  for_each   = { for context in var.export_route_map_contexts : context.name => context }
  dn         = "${aci_rest.rtctrlProfile_export[0].dn}/ctx-${each.value.name}"
  class_name = "rtctrlCtxP"
  content = {
    name   = each.value.name
    descr  = each.value.description != null ? each.value.description : ""
    action = each.value.action != null ? each.value.action : "permit"
    order  = each.value.order != null ? each.value.order : "0"
  }
}

resource "aci_rest" "rtctrlScope_export" {
  for_each   = { for context in var.export_route_map_contexts : context.name => context if context.set_rule != null && context.set_rule != "" }
  dn         = "${aci_rest.rtctrlCtxP_export[each.value.name].dn}/scp"
  class_name = "rtctrlScope"
}

resource "aci_rest" "rtctrlRsScopeToAttrP_export" {
  for_each   = { for context in var.export_route_map_contexts : context.name => context if context.set_rule != null && context.set_rule != "" }
  dn         = "${aci_rest.rtctrlScope_export[each.value.name].dn}/rsScopeToAttrP"
  class_name = "rtctrlRsScopeToAttrP"
  content = {
    tnRtctrlAttrPName = each.value.set_rule
  }
}

resource "aci_rest" "rtctrlRsCtxPToSubjP_export" {
  for_each   = { for context in var.export_route_map_contexts : context.name => context if context.match_rule != null && context.match_rule != "" }
  dn         = "${aci_rest.rtctrlCtxP_export[each.value.name].dn}/rsctxPToSubjP-${each.value.match_rule}"
  class_name = "rtctrlRsCtxPToSubjP"
  content = {
    tnRtctrlSubjPName = each.value.match_rule
  }
}
