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
  # Customer Azure Subscrption information
  customer = lookup(local.config, "customer", {})
  # Common defaults for SAP Landscape-wide resources
  default = lookup(local.config, "default", {})
  # Azure Resource abpreviations
  resource_name = lookup(local.config, "resource_name", {})
  # Naming Scheme for Azure Resources
  customer_naming_scheme = lookup(local.config, "customer_naming_scheme", {})
  # Common tags for the environment and Azure Resources
  tags = lookup(local.config, "tags", {})
  # Diagnostics settings
  diagnostics = lookup(local.config, "diagnostics", {})
  # Diagnostics enabled for Azure Resources
  diagnostics_enabled = lookup(local.diagnostics, "enabled", {})
  # Diagnostics logging categories for Azure Resources
  diagnostics_categories = lookup(local.diagnostics, "categories", {})
  # Management Locks for Azure Resources
  management_lock = lookup(local.config, "management_lock", {})
  # Group map deployment to Resources Groups and default values
  group = lookup(local.config, "groups", {})
  # Azure Resource Groups
  resource_group = lookup(local.config, "resource_groups", {})
  # Azure Log Analytics
  config_log_analytics = lookup(local.config, "log_analytics", {})
}