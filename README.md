# terraform-oci-fk-fastconnect

This repository contains a reusable **Terraform/OpenTofu module** for deploying **Oracle Cloud Infrastructure (OCI) FastConnect connectivity primitives** such as **private virtual circuits** and optional **DRG attachment management**.

It is part of the **[FoggyKitchen.com training ecosystem](https://foggykitchen.com/courses-2/)** and serves as the OCI private interconnect edge building block for hybrid and multicloud connectivity patterns.

Support expectations are documented in [SUPPORT.md](SUPPORT.md).

---

## 🎯 Purpose

The goal of this module is to provide a **clean, composable, and educational reference implementation** for OCI FastConnect edge connectivity:

- Focused on **virtual circuit and DRG attachment management resources**
- No hidden DRG, VCN, or subnet creation
- Designed to be composed with **terraform-oci-fk-drg** and cloud-specific private connectivity modules

This is **not** a full landing zone replacement. It is a **connectivity edge module** intended for learning, reuse, and composition.

---

## ✨ What the module does

The module creates:

- OCI FastConnect private virtual circuit
- Optional DRG attachment management for the virtual circuit
- Optional provider service lookup by provider name

The module intentionally does **not** create:

- DRGs
- VCNs
- Subnets
- VCN route tables
- Compute instances

Each of those concerns belongs in its own dedicated module or composition layer.

---

## 📂 Repository Structure

```bash
terraform-oci-fk-fastconnect/
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── LICENSE
└── README.md
```

---

## 🚀 Example Usage

```hcl
module "fastconnect" {
  source = "git::https://github.com/foggykitchen/terraform-oci-fk-fastconnect.git?ref=v0.1.1"

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

## ⚙️ Module Inputs

### Core inputs

| Variable | Type | Required | Description |
|--------|------|----------|-------------|
| `compartment_ocid` | `string` | ✅ | Compartment OCID where the FastConnect virtual circuit will be created |
| `name` | `string` | ✅ | Base name used for the FastConnect resources |
| `display_name` | `string` | ❌ | Optional display name override |
| `drg_id` | `string` | ✅ | Target DRG OCID |
| `type` | `string` | ❌ | Virtual circuit type |
| `bandwidth_shape_name` | `string` | ✅ | FastConnect bandwidth shape |
| `provider_service_id` | `string` | ❌ | Explicit provider service ID |
| `provider_name` | `string` | ❌ | Provider name used for provider service lookup |
| `provider_service_key_name` | `string` | ✅ | Provider-side service key |
| `cross_connect_mappings` | `list(object)` | ❌ | BGP peering mappings |
| `defined_tags` | `map(string)` | ❌ | Defined tags |
| `freeform_tags` | `map(string)` | ❌ | Freeform tags |

### Attachment management objects

| Variable | Type | Required | Description |
|--------|------|----------|-------------|
| `attachment_management` | `object` | ❌ | Optional DRG attachment management object for associating the virtual circuit with a DRG route table |

### Attachment management object schema

```hcl
attachment_management = object({
  drg_route_table_id = string
  compartment_ocid   = optional(string)
  display_name       = optional(string)
})
```

---

## 📤 Outputs

| Output | Description |
|------|-------------|
| `virtual_circuit_id` | FastConnect virtual circuit OCID |
| `virtual_circuit_name` | FastConnect virtual circuit display name |
| `provider_service_id` | Resolved provider service ID |
| `drg_attachment_management_id` | DRG attachment management OCID, if created |

---

## 🧠 Design Philosophy

- Explicit over implicit
- Small modules over monoliths
- DRG connectivity separated from FastConnect edge configuration
- Optimized for **learning, reuse, and composition**

This makes the module useful for:

- OCI-to-Azure private interconnect
- OCI partner connectivity foundations
- Multicloud private networking labs
- Progressive connectivity building blocks

---

## 📌 Notes

- This module focuses on OCI FastConnect edge primitives rather than full topologies
- DRG-side routing should remain modeled in **terraform-oci-fk-drg**
- VCN route tables should remain modeled in **terraform-oci-fk-vcn** or a composition layer

---

## 🌐 Learn More

Visit [FoggyKitchen.com](https://foggykitchen.com/) for OCI, multicloud, and Terraform/OpenTofu learning resources.

---

## 🪪 License

Licensed under the **Universal Permissive License (UPL), Version 1.0**.  
See [LICENSE](LICENSE) for details.

---

© 2026 [FoggyKitchen.com](https://foggykitchen.com) - Cloud. Code. Clarity.
