variable "compartment_ocid" {
  description = "Compartment OCID where the FastConnect virtual circuit will be created."
  type        = string
}

variable "name" {
  description = "Base name used for the FastConnect resources."
  type        = string
}

variable "display_name" {
  description = "Optional display name override for the virtual circuit."
  type        = string
  default     = null
}

variable "drg_id" {
  description = "DRG OCID used as the virtual circuit gateway target."
  type        = string
}

variable "type" {
  description = "Virtual circuit type."
  type        = string
  default     = "PRIVATE"
}

variable "bandwidth_shape_name" {
  description = "OCI FastConnect bandwidth shape."
  type        = string
}

variable "provider_service_id" {
  description = "Optional OCI FastConnect provider service ID. When omitted, the module resolves it by provider name."
  type        = string
  default     = null
}

variable "provider_name" {
  description = "FastConnect provider name used for provider service lookup."
  type        = string
  default     = "Microsoft Azure"
}

variable "provider_service_key_name" {
  description = "Provider-side service key, for example the Azure ExpressRoute service key."
  type        = string
}

variable "cross_connect_mappings" {
  description = "BGP peering mappings for the virtual circuit."
  type = list(object({
    oracle_bgp_peering_ip   = string
    customer_bgp_peering_ip = string
  }))
  default = []
}

variable "attachment_management" {
  description = "Optional DRG attachment management for associating the virtual circuit with a DRG route table."
  type = object({
    drg_route_table_id = string
    compartment_ocid   = optional(string)
    display_name       = optional(string)
  })
  default = null
}

variable "defined_tags" {
  description = "Defined tags applied to created resources."
  type        = map(string)
  default     = {}
}

variable "freeform_tags" {
  description = "Freeform tags applied to created resources."
  type        = map(string)
  default     = {}
}
