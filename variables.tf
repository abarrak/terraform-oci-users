variable "tenancy_id" {
  description = "The OCID of tenancy."
  type        = string
}

variable "compartment_id" {
  description = "The OCID of compartment to provison resources in (except tenancy-level resources)."
  type        = string
}

variable "local_users" {
  description = "A list of local users or service accounts to provision including group name and policy statements list."
  type        = list(object({ username = string, group = string, description = string, policy = list(string) }))
  default     = []
}

variable "capabilities" {
  description = "(Optional) The capabilities allowed and provisioned for local users or service accounts."
  type        = object({ api_keys = string, auth_tokens = string, smtp_credentials = string,
                         console_password = string, customer_secret_keys = string })
  default     = {
    api_keys = "true",
    auth_tokens = "false",
    smtp_credentials = "false",
    console_password = "false",
    customer_secret_keys = "true"
  }
}

variable "tags" {
  description = "(Optional) tags to attach to the provisioned resources."
  type        = map(any)
}
