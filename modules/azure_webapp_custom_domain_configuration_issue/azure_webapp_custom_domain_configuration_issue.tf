resource "shoreline_notebook" "azure_webapp_custom_domain_configuration_issue" {
  name       = "azure_webapp_custom_domain_configuration_issue"
  data       = file("${path.module}/data/azure_webapp_custom_domain_configuration_issue.json")
  depends_on = [shoreline_action.invoke_dns_mapping]
}

resource "shoreline_file" "dns_mapping" {
  name             = "dns_mapping"
  input_file       = "${path.module}/data/dns_mapping.sh"
  md5              = filemd5("${path.module}/data/dns_mapping.sh")
  description      = "Check and update the DNS settings to ensure that the custom domain is correctly mapped to the web app's IP address."
  destination_path = "/tmp/dns_mapping.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_dns_mapping" {
  name        = "invoke_dns_mapping"
  description = "Check and update the DNS settings to ensure that the custom domain is correctly mapped to the web app's IP address."
  command     = "`chmod +x /tmp/dns_mapping.sh && /tmp/dns_mapping.sh`"
  params      = ["ZONE_NAME","WEBAPP_NAME","YOURDOMAIN","RESOURCE_GROUP_NAME"]
  file_deps   = ["dns_mapping"]
  enabled     = true
  depends_on  = [shoreline_file.dns_mapping]
}

