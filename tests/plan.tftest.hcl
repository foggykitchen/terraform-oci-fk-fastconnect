mock_provider "oci" {
  mock_data "oci_core_fast_connect_provider_services" {
    defaults = {
      fast_connect_provider_services = [{
        id                              = "mock-provider-service"
        provider_name                   = "Microsoft Azure"
        bandwith_shape_management       = "CUSTOMER_MANAGED"
        customer_asn_management         = "CUSTOMER_MANAGED"
        description                     = "Mock provider service"
        private_peering_bgp_management  = "CUSTOMER_MANAGED"
        provider_service_key_management = "CUSTOMER_MANAGED"
        provider_service_name           = "Mock service"
        public_peering_bgp_management   = "CUSTOMER_MANAGED"
        required_total_cross_connects   = 1
        supported_virtual_circuit_types = ["PRIVATE"]
        type                            = "LAYER2"
      }]
    }
  }
}

variables {
  compartment_ocid          = "mock-compartment"
  name                      = "compatibility"
  drg_id                    = "mock-drg"
  bandwidth_shape_name      = "1 Gbps"
  provider_service_key_name = "mock-service-key"
}

run "provider_lookup" {
  command = plan

  assert {
    condition     = output.provider_service_id == "mock-provider-service"
    error_message = "The provider service must resolve by its configured name."
  }
}

run "explicit_provider_and_attachment" {
  command = plan
  variables {
    provider_service_id = "mock-explicit-provider"
    attachment_management = {
      drg_route_table_id = "mock-route-table"
    }
    cross_connect_mappings = [{
      oracle_bgp_peering_ip   = "192.0.2.1/30"
      customer_bgp_peering_ip = "192.0.2.2/30"
    }]
  }
  assert {
    condition     = output.provider_service_id == "mock-explicit-provider" && length(oci_core_drg_attachment_management.this) == 1
    error_message = "An explicit service and requested DRG attachment must be preserved."
  }
}
