data "oci_core_fast_connect_provider_services" "this" {
  count = var.provider_service_id == null ? 1 : 0

  compartment_id = var.compartment_ocid
}

locals {
  resolved_provider_service_id = var.provider_service_id != null ? var.provider_service_id : data.oci_core_fast_connect_provider_services.this[0].fast_connect_provider_services[
    index(data.oci_core_fast_connect_provider_services.this[0].fast_connect_provider_services.*.provider_name, var.provider_name)
  ].id
}

resource "oci_core_virtual_circuit" "this" {
  compartment_id            = var.compartment_ocid
  display_name              = coalesce(var.display_name, var.name)
  gateway_id                = var.drg_id
  type                      = var.type
  bandwidth_shape_name      = var.bandwidth_shape_name
  provider_service_id       = local.resolved_provider_service_id
  provider_service_key_name = var.provider_service_key_name

  dynamic "cross_connect_mappings" {
    for_each = var.cross_connect_mappings
    content {
      oracle_bgp_peering_ip   = cross_connect_mappings.value.oracle_bgp_peering_ip
      customer_bgp_peering_ip = cross_connect_mappings.value.customer_bgp_peering_ip
    }
  }

  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags
}

resource "oci_core_drg_attachment_management" "this" {
  count = var.attachment_management == null ? 0 : 1

  compartment_id     = coalesce(try(var.attachment_management.compartment_ocid, null), var.compartment_ocid)
  attachment_type    = "VIRTUAL_CIRCUIT"
  display_name       = coalesce(try(var.attachment_management.display_name, null), "${var.name}-attachment-management")
  network_id         = oci_core_virtual_circuit.this.id
  drg_id             = var.drg_id
  drg_route_table_id = var.attachment_management.drg_route_table_id
}
