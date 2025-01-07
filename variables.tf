variable "tenancy_id" {
  description = "The OCID of tenancy."
  type        = string
}

variable "compartment_id" {
  description = "The OCID of compartment to provison resources in (except tenancy-level resources)."
  type        = string
}

variable "local_svc_account_users" {
  description = "A list of local users or service accounts to provision including group name and policy statements list."
  type        = list(object({ username = string, group = string, description = string, policy = list(string) }))
  default     = []
}

variable "tags" {
  description = "(Optional) tags to attach to the provisioned resources."
  type        = map(any)
}
