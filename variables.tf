variable "transform_path" {
  description = "the path to mount the transform path"
  default     = "transform"
}

variable "fpe_transformation_name" {
  description = "the name to give the custom fpe transformation"
  default     = "fpe_phone"
}

variable "masking_transformation_name" {
  description = "the name to give the custom masking transformation"
  default     = "masking_phone"
}

variable "transformation_template_name" {
  description = "the name to give the custom transformation template"
  default     = "us_phone"
}

variable "transformation_role_name" {
  description = "the name to give the transformation tole"
  default     = "phone_number"
}

variable "template_regex_pattern" {
  description = "the regex the transformation template will use"
  default     = "\\+\\d{1,2} (\\d{3})-(\\d{3})-(\\d{4})"
}