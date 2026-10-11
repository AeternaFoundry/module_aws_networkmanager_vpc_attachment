variable "networkmanager_vpc_attachments" {
  description = <<EOT
Map of networkmanager_vpc_attachments, attributes below
Required:
    - core_network_id
    - subnet_arns
    - vpc_arn
Optional:
    - routing_policy_label
    - tags
    - tags_all
    - options (block):
        - appliance_mode_support (optional)
        - dns_support (optional)
        - ipv6_support (optional)
        - security_group_referencing_support (optional)
EOT

  type = map(object({
    core_network_id      = string
    subnet_arns          = set(string)
    vpc_arn              = string
    routing_policy_label = optional(string)
    tags                 = optional(map(string))
    tags_all             = optional(map(string))
    options = optional(object({
      appliance_mode_support             = optional(bool)
      dns_support                        = optional(bool)
      ipv6_support                       = optional(bool)
      security_group_referencing_support = optional(bool)
    }))
  }))
  validation {
    condition = alltrue([
      for k, v in var.networkmanager_vpc_attachments : (
        v.routing_policy_label == null || (length(v.routing_policy_label) >= 0 && length(v.routing_policy_label) <= 256)
      )
    ])
    error_message = "must be between 0 and 256 characters"
  }
  # Note: 2 additional provider-side validators are enforced at apply time but not mirrored as validation{} blocks here (bespoke or non-mechanically-translatable).
}

