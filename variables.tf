variable "tenant" {
  description = "Tenant name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.tenant))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "name" {
  description = "L3out name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.name))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "alias" {
  description = "Alias."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.alias))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "description" {
  description = "Description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "routed_domain" {
  description = "Routed domain name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.routed_domain))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "vrf" {
  description = "VRF name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]{0,64}$", var.vrf))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "ospf" {
  description = "Enable OSPF routing."
  type        = bool
  default     = false
}

variable "bgp" {
  description = "Enable BGP routing."
  type        = bool
  default     = false
}

variable "ospf_area" {
  description = "OSPF area. Allowed values are `backbone` or a number between 1 and 4294967295."
  type        = string
  default     = "backbone"

  validation {
    condition     = try(contains(["backbone"], var.ospf_area), false) || try(can(regex("^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.ospf_area)), false)
    error_message = "Allowed values are `backbone` or an id in dotted notation e.g., `0.0.0.10`."
  }
}

variable "ospf_area_cost" {
  description = "OSPF area cost. Minimum value: 1. Maximum value: 16777215."
  type        = number
  default     = 1

  validation {
    condition     = var.ospf_area_cost >= 1 && var.ospf_area_cost <= 16777215
    error_message = "Minimum value: 1. Maximum value: 16777215."
  }
}

variable "ospf_area_type" {
  description = "OSPF area type. Choices: `regular`, `stub`, `nssa`."
  type        = string
  default     = "regular"

  validation {
    condition     = contains(["regular", "stub", "nssa"], var.ospf_area_type)
    error_message = "Allowed values are `regular`, `stub` or `nssa`."
  }
}

variable "import_route_map_description" {
  description = "Import route map description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.import_route_map_description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "import_route_map_type" {
  description = "Import route map type. Choices: `combinable`, `global`."
  type        = string
  default     = "combinable"

  validation {
    condition     = contains(["combinable", "global"], var.import_route_map_type)
    error_message = "Allowed values are `combinable` or `global`."
  }
}

variable "import_route_map_contexts" {
  description = "List of import route map contexts. Choices `action`: `permit`, `deny`. Default value `action`: `permit`. Allowed values `order`: 0-9. Default value `order`: 0."
  type = list(object({
    name        = string
    description = optional(string)
    action      = optional(string)
    order       = optional(number)
    set_rule    = optional(string)
    match_rule  = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for c in var.import_route_map_contexts : can(regex("^[a-zA-Z0-9_.-]{0,64}$", c.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for c in var.import_route_map_contexts : c.description == null || try(can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", c.description)), false)
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for c in var.import_route_map_contexts : c.action == null || try(contains(["permit", "deny"], c.action), false)
    ])
    error_message = "`action`: Allowed values are `permit` or `deny`."
  }

  validation {
    condition = alltrue([
      for c in var.import_route_map_contexts : c.order == null || try(c.order >= 0 && c.order <= 9, false)
    ])
    error_message = "`order`: Minimum value: 0. Maximum value: 9."
  }

  validation {
    condition = alltrue([
      for c in var.import_route_map_contexts : c.set_rule == null || try(can(regex("^[a-zA-Z0-9_.-]{0,64}$", c.set_rule)), false)
    ])
    error_message = "`set_rule`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for c in var.import_route_map_contexts : c.match_rule == null || try(can(regex("^[a-zA-Z0-9_.-]{0,64}$", c.match_rule)), false)
    ])
    error_message = "`match_rule`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}

variable "export_route_map_description" {
  description = "Import route map description."
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", var.export_route_map_description))
    error_message = "Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }
}

variable "export_route_map_type" {
  description = "Import route map type. Choices: `combinable`, `global`."
  type        = string
  default     = "combinable"

  validation {
    condition     = contains(["combinable", "global"], var.export_route_map_type)
    error_message = "Allowed values are `combinable` or `global`."
  }
}

variable "export_route_map_contexts" {
  description = "List of export route map contexts. Choices `action`: `permit`, `deny`. Default value `action`: `permit`. Allowed values `order`: 0-9. Default value `order`: 0."
  type = list(object({
    name        = string
    description = optional(string)
    action      = optional(string)
    order       = optional(number)
    set_rule    = optional(string)
    match_rule  = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for c in var.export_route_map_contexts : can(regex("^[a-zA-Z0-9_.-]{0,64}$", c.name))
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for c in var.export_route_map_contexts : c.description == null || try(can(regex("^[a-zA-Z0-9\\!#$%()*,-./:;@ _{|}~?&+]{0,128}$", c.description)), false)
    ])
    error_message = "`name`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `\\`, `!`, `#`, `$`, `%`, `(`, `)`, `*`, `,`, `-`, `.`, `/`, `:`, `;`, `@`, ` `, `_`, `{`, `|`, }`, `~`, `?`, `&`, `+`. Maximum characters: 128."
  }

  validation {
    condition = alltrue([
      for c in var.export_route_map_contexts : c.action == null || try(contains(["permit", "deny"], c.action), false)
    ])
    error_message = "`action`: Allowed values are `permit` or `deny`."
  }

  validation {
    condition = alltrue([
      for c in var.export_route_map_contexts : c.order == null || try(c.order >= 0 && c.order <= 9, false)
    ])
    error_message = "`order`: Minimum value: 0. Maximum value: 9."
  }

  validation {
    condition = alltrue([
      for c in var.export_route_map_contexts : c.set_rule == null || try(can(regex("^[a-zA-Z0-9_.-]{0,64}$", c.set_rule)), false)
    ])
    error_message = "`set_rule`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }

  validation {
    condition = alltrue([
      for c in var.export_route_map_contexts : c.match_rule == null || try(can(regex("^[a-zA-Z0-9_.-]{0,64}$", c.match_rule)), false)
    ])
    error_message = "`match_rule`: Allowed characters: `a`-`z`, `A`-`Z`, `0`-`9`, `_`, `.`, `-`. Maximum characters: 64."
  }
}
