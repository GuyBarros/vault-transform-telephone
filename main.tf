resource "vault_mount" "transform" {
  path = var.transform_path
  type = "transform"
}

resource "vault_transform_template" "phone-template" {
  path     = vault_mount.transform.path
  name     = var.transformation_template_name
  type     = "regex"
  pattern  = var.template_regex_pattern
  alphabet = "builtin/numeric"
}

#FPE Encode
resource "vault_transform_transformation" "fpe_phone" {
  path             = vault_mount.transform.path
  name             = var.fpe_transformation_name
  type             = "fpe"
  template         = vault_transform_template.phone-template.name
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}

#Masking
resource "vault_transform_transformation" "masking_phone" {
  path              = vault_mount.transform.path
  name              = var.masking_transformation_name
  type              = "masking"
  masking_character = "#"
  template          = vault_transform_template.phone-template.name
  tweak_source      = "internal"
  allowed_roles     = ["*"]
  deletion_allowed  = true
}

resource "vault_transform_role" "phone" {
  path            = vault_mount.transform.path
  name            = var.transformation_role_name
  transformations = [vault_transform_transformation.fpe_phone.name, vault_transform_transformation.masking_phone.name, vault_transform_transformation.us_phone.name]
}


data "vault_transform_encode" "test" {
  path      = vault_transform_role.phone.path
  role_name = vault_transform_role.phone.name
  # transformation = vault_transform_transformation.fpe_phone.name
  batch_input = [{ "value" : "+1 123-345-5678", "transformation" : vault_transform_transformation.fpe_phone.name },
                 { "value" : "+1 123-345-5678", "transformation" : vault_transform_transformation.masking_phone.name },
                 { "value" : "555-8675309", "transformation" : vault_transform_transformation.us_phone.name }
                 ]
}

#TEMPLATE Test
resource "vault_transform_template" "us-template" {
  path     = vault_mount.transform.path
  name     = "us-transform-template"
  type     = "regex"
  pattern  = "\\d{3}-(\\d{7})"
  alphabet = "builtin/numeric"
}

resource "vault_transform_transformation" "us_phone" {
  path             = vault_mount.transform.path
  name             = "us-transform"
  type             = "fpe"
  template         = vault_transform_template.us-template.name
  tweak_source     = "internal"
  allowed_roles    = ["*"]
  deletion_allowed = true
}