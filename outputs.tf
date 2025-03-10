output "local_users_ids" {
  description = "The ocid values for the local svc-account users."
  value       = values(oci_identity_user.local_users)[*].id
}

output "local_user_statuses" {
  description = "The status for the local svc-account users."
  value       = values(oci_identity_user.local_users)[*].state
}

output "local_group_ids" {
  description = "The ocid value for the local svc-account user groups."
  value       = values(oci_identity_group.local_groups)[*].id
}

output "local_policies_ids" {
  description = "The ocid value for the local svc-account user policies."
  value       = values(oci_identity_policy.local_policies)[*].id
}

output "local_users_api_key_ids" {
  description = "An Oracle-assigned identifier for the key, in this format: TENANCY_OCID/USER_OCID/KEY_FINGERPRINT."
  value       = values(oci_identity_api_key.local_users_api_keys)[*].id
}

output "local_users_api_key_fingerprints" {
  description = "The key's fingerprint (e.g., 12:34:56:78:90:ab:cd:ef:12:34:56:78:90:ab:cd:ef)."
  value       = values(oci_identity_api_key.local_users_api_keys)[*].fingerprint
}
