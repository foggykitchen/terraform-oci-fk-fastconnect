# terraform-oci-fk-fastconnect

This repository contains a reusable **Terraform / OpenTofu module** for deploying an **OCI FastConnect virtual circuit** and, when needed, the **DRG attachment management** resource that binds the circuit to a DRG route table.

---

## Purpose

The module is intended for composable OCI connectivity stacks where:

- the DRG is created in a separate reusable module
- the provider service may be resolved by provider name or passed explicitly
- the virtual circuit needs to be attached to an existing DRG route table

It is designed to compose cleanly with `terraform-oci-fk-drg` and Azure-side ExpressRoute modules.

---

## What the module does

The module creates:

- one `oci_core_virtual_circuit`
- optional `oci_core_drg_attachment_management` for `VIRTUAL_CIRCUIT`

The module intentionally does **not** create:

- DRGs
- VCNs
- Subnets
- VCN route tables

Those resources should be composed separately.

---

## Example Usage

```hcl
module "fastconnect" {
  source = "git::https://github.com/mlinxfeld/terraform-oci-fk-fastconnect.git?ref=v0.1.0"

  compartment_ocid          = var.compartment_ocid
  name                      = "fc-fk-demo"
  drg_id                    = module.drg.drg_id
  bandwidth_shape_name      = "1 Gbps"
  provider_service_key_name = module.expressroute.service_key

  attachment_management = {
    drg_route_table_id = module.drg.drg_route_table_ids["interconnect"]
  }
}
```

---

## Inputs

| Variable | Required | Description |
|------|------|-------------|
| `compartment_ocid` | ✅ | Compartment OCID |
| `name` | ✅ | Base name for FastConnect resources |
| `display_name` | ❌ | Optional display name override |
| `drg_id` | ✅ | Target DRG OCID |
| `type` | ❌ | Virtual circuit type |
| `bandwidth_shape_name` | ✅ | FastConnect bandwidth shape |
| `provider_service_id` | ❌ | Explicit provider service ID |
| `provider_name` | ❌ | Provider name for lookup |
| `provider_service_key_name` | ✅ | Provider-side service key |
| `cross_connect_mappings` | ❌ | BGP peering mappings |
| `attachment_management` | ❌ | Optional DRG attachment management object |
| `defined_tags` | ❌ | Defined tags |
| `freeform_tags` | ❌ | Freeform tags |

### Attachment management schema

```hcl
attachment_management = object({
  drg_route_table_id = string
  compartment_ocid   = optional(string)
  display_name       = optional(string)
})
```

---

## Outputs

| Output | Description |
|------|-------------|
| `virtual_circuit_id` | FastConnect virtual circuit OCID |
| `virtual_circuit_name` | FastConnect virtual circuit display name |
| `provider_service_id` | Resolved provider service ID |
| `drg_attachment_management_id` | DRG attachment management OCID, if created |

---

## License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.
