#
# Read configuration files
#

locals {
  #
  # Set of all configuration files (supported prefixes)
  config_json_files = setunion(
    fileset("${path.cwd}/${path.module}", "aws-*.json")
  )
  #
  # Read all configuration files into array
  config_json_files_content = [
    for input_file in local.config_json_files : file("${path.module}/${input_file}")
  ]
  #
  # Decode deep merged configuration files from JSON to Terraform object
  # deepmerge from a provider is used to allow same key to be defined
  # in multiple JSON files for improved clarity.
  config = jsondecode(data.utils_deep_merge_json.config.output)
}

data "utils_deep_merge_json" "config" {
  input = local.config_json_files_content
}

#
# Common configuration details required by most code modules
#

locals {
  # Customer AWS Subscrption information
  customer = lookup(local.config, "customer", {})
  # Common defaults for SAP Landscape-wide resources
  default = lookup(local.config, "default", {})
  # AWS Resource abpreviations
  resource_name = lookup(local.config, "resource_name", {})
  # Naming Scheme for AWS Resources
  customer_naming_scheme = lookup(local.config, "customer_naming_scheme", {})
  # Common tags for the environment and AWS Resources
  tags = lookup(local.config, "tags", {})
  # Group map deployment to Resources Groups and default values
  group = lookup(local.config, "groups", {})
}