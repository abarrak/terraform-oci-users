resource "oci_identity_user" "local_svc_account_users" {
  for_each = { for idx, u in var.local_svc_account_users : u.username => u }

  compartment_id = var.tenancy_id
  name           = each.value.username
  description    = each.value.description

  freeform_tags = var.tags
}

resource "oci_identity_group" "local_svc_account_groups" {
  for_each = { for idx, u in var.local_svc_account_users : u.group => u }

  compartment_id = var.tenancy_id
  name           = each.value.group
  description    = each.value.description

  freeform_tags = var.tags
}

resource "oci_identity_policy" "local_svc_account_policies" {
  for_each = { for idx, u in var.local_svc_account_users : u.group => u }

  compartment_id = var.compartment_id
  name           = each.value.group
  statements     = each.value.policy
  description    = each.value.description

  freeform_tags = var.tags
}

resource "oci_identity_user_group_membership" "local_svc_account_memberships" {
  for_each = { for idx, u in var.local_svc_account_users : u.group => u }

  user_id  = oci_identity_user.local_svc_account_users[each.value.username].id
  group_id = oci_identity_group.local_svc_account_groups[each.key].id
}

resource "oci_identity_user_capabilities_management" "local_svc_account_capabilities" {
  for_each = oci_identity_user.local_svc_account_users

  user_id = each.value.id

  can_use_api_keys             = "true"
  can_use_auth_tokens          = "false"
  can_use_smtp_credentials     = "false"
  can_use_console_password     = "false"
  can_use_customer_secret_keys = "true"
}


resource "oci_identity_customer_secret_key" "local_svc_account_secret_keys" {
  for_each = oci_identity_user.local_svc_account_users

  user_id      = each.value.id
  display_name = "${each.value.name}-customer-key"
}

resource "oci_vault_secret" "local_svc_account_customer_secret_keys" {
  for_each = oci_identity_customer_secret_key.local_svc_account_secret_keys

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

resource "oci_vault_secret" "local_svc_account_oci_s3_credentials" {
  for_each = oci_identity_customer_secret_key.local_svc_account_secret_keys

  compartment_id = var.compartment_id
  vault_id       = data.oci_kms_vaults.compartment_vaults.vaults[0].id
  key_id         = data.oci_kms_keys.compartment_keys.keys[0].id

  secret_name = "${each.value.display_name}-oci-s3-creds"

  secret_content {
    content_type = "BASE64"
    stage        = "CURRENT"
    name         = "${each.value.display_name}-oci-creds"
    content      = base64encode("[default]\naws_access_key_id=${each.value.id}\naws_secret_access_key=${each.value.key}\n")
  }
}
