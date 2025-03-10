resource "oci_identity_user" "local_users" {
  for_each = { for idx, u in var.local_users : u.username => u }

  compartment_id = var.tenancy_id
  name           = each.value.username
  description    = each.value.description

  freeform_tags = var.tags
}

resource "oci_identity_group" "local_groups" {
  for_each = { for idx, u in var.local_users : u.group => u }

  compartment_id = var.tenancy_id
  name           = each.value.group
  description    = each.value.description

  freeform_tags = var.tags
}

resource "oci_identity_policy" "local_policies" {
  for_each = { for idx, u in var.local_users : u.group => u }

  compartment_id = var.compartment_id
  name           = each.value.group
  statements     = each.value.policy
  description    = each.value.description

  freeform_tags = var.tags
}

resource "oci_identity_user_group_membership" "local_memberships" {
  for_each = { for idx, u in var.local_users : u.group => u }

  user_id  = oci_identity_user.local_users[each.value.username].id
  group_id = oci_identity_group.local_groups[each.key].id
}

resource "oci_identity_user_capabilities_management" "local_capabilities" {
  for_each = oci_identity_user.local_users

  user_id = each.value.id

  can_use_api_keys             = var.local_users_capabilities.api_keys
  can_use_auth_tokens          = var.local_users_capabilities.auth_tokens
  can_use_smtp_credentials     = var.local_users_capabilities.smtp_credentials
  can_use_console_password     = var.local_users_capabilities.console_password
  can_use_customer_secret_keys = var.local_users_capabilities.customer_secret_keys
}

resource "tls_private_key" "local_users_rsa_api_keys" {
  for_each = bool(var.capabilities.api_keys) ? oci_identity_user.local_users : []

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "oci_identity_api_key" "local_users_api_keys" {
  for_each = bool(var.capabilities.api_keys) ? oci_identity_user.local_users : []

  user_id   = each.value.id
  key_value = tls_private_key.local_users_rsa_api_keys[each.index].public_key_pem
}

resource "oci_vault_secret" "local_users_api_keys_secret" {
  for_each = bool(var.capabilities.api_keys) ? oci_identity_customer_secret_key.local_users_api_keys : []

  compartment_id = var.compartment_id
  vault_id       = data.oci_kms_vaults.compartment_vaults.vaults[0].id
  key_id         = data.oci_kms_keys.compartment_keys.keys[0].id

  secret_name = "${each.value.display_name}-api-key"

  secret_content {
    content_type = "BASE64"
    stage        = "CURRENT"
    name         = "${each.value.display_name}-api-key"
    content = base64encode(tls_private_key.local_users_rsa_api_keys[each.index].private_key_pem)
  }
}

resource "oci_identity_customer_secret_key" "local_users_secret_keys" {
  for_each = bool(var.capabilities.customer_secret_keys) ? oci_identity_user.local_users : []

  user_id      = each.value.id
  display_name = "${each.value.name}-customer-key"
}

resource "oci_vault_secret" "local_users_customer_secret_keys" {
  for_each = bool(var.capabilities.customer_secret_keys) ? oci_identity_customer_secret_key.local_users_secret_keys : []

  compartment_id = var.compartment_id
  vault_id       = data.oci_kms_vaults.compartment_vaults.vaults[0].id
  key_id         = data.oci_kms_keys.compartment_keys.keys[0].id

  secret_name = "${each.value.display_name}-s3-creds"

  secret_content {
    content_type = "BASE64"
    stage        = "CURRENT"
    name         = "${each.value.display_name}-s3-creds"
    content = base64encode(jsonencode({
      "aws_access_key" : each.value.id,
      "aws_secret_access_key" : each.value.key,
      "aws_access_key_url_encoded" : urlencode(each.value.id),
      "aws_secret_access_key_url_encoded" : urlencode(each.value.key)
    }))
  }
}

resource "oci_vault_secret" "local_users_oci_s3_format_credentials" {
  for_each = bool(var.capabilities.customer_secret_keys) ? oci_identity_customer_secret_key.local_users_secret_keys : []

  compartment_id = var.compartment_id
  vault_id       = data.oci_kms_vaults.compartment_vaults.vaults[0].id
  key_id         = data.oci_kms_keys.compartment_keys.keys[0].id

  secret_name = "${each.value.display_name}-oci-s3-creds"

  secret_content {
    content_type = "BASE64"
    stage        = "CURRENT"
    name         = "${each.value.display_name}-oci-creds"
    content      = base64encode(
      "[default]\naws_access_key_id=${each.value.id}\naws_secret_access_key=${each.value.key}\n"
    )
  }
}
