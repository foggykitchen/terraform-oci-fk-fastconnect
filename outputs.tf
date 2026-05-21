output "virtual_circuit_id" {
  description = "FastConnect virtual circuit OCID."
  value       = oci_core_virtual_circuit.this.id
}

output "virtual_circuit_name" {
  description = "FastConnect virtual circuit display name."
  value       = oci_core_virtual_circuit.this.display_name
}

output "provider_service_id" {
  description = "Resolved OCI FastConnect provider service ID."
  value       = local.resolved_provider_service_id
}

output "drg_attachment_management_id" {
  description = "DRG attachment management OCID when created."
  value       = try(oci_core_drg_attachment_management.this[0].id, null)
}
