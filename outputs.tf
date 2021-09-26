output "dn" {
  value       = aci_rest.l3extOut.id
  description = "Distinguished name of `l3extOut` object."
}

output "name" {
  value       = aci_rest.l3extOut.content.name
  description = "L3out name."
}
