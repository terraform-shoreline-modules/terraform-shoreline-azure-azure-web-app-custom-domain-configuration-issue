
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Azure WebApp Custom Domain Configuration Issue
---

This incident type refers to an issue with custom domain configuration for an Azure WebApp, where the custom domain (e.g., www.yourdomain.com) is not working with the web app. The incident requires investigation of DNS settings, validation of correct mapping to App Service, and configuration of SSL bindings if needed to resolve the issue.

### Parameters
```shell
export RESOURCE_GROUP_NAME="PLACEHOLDER"

export WEBAPP_NAME="PLACEHOLDER"

export CERTIFICATE_NAME="PLACEHOLDER"

export ZONE_NAME="PLACEHOLDER"

export YOURDOMAIN="PLACEHOLDER"
```

## Debug

### Check the WebApp's custom domain settings
```shell
az webapp config hostname list --resource-group ${RESOURCE_GROUP_NAME} --webapp-name ${WEBAPP_NAME}
```

### Check the WebApp's SSL bindings
```shell
az webapp config ssl list --resource-group ${RESOURCE_GROUP_NAME}
```

### Verify the SSL certificate config details
```shell
az webapp config ssl show --resource-group ${RESOURCE_GROUP_NAME} --certificate-name ${CERTIFICATE_NAME}
```

### Get the list of name servers for your zone
```shell
az network dns record-set ns show --resource-group ${RESOURCE_GROUP_NAME} --zone-name ${ZONE_NAME} --name @
```

### Check the DNS validation record settings for the custom domain
```shell
az network dns record-set txt show --resource-group ${RESOURCE_GROUP_NAME} --zone-name ${ZONE_NAME} --name @
```

### Check the mapping of the custom domain to the WebApp's IP address
```shell
az network dns record-set a show --resource-group ${RESOURCE_GROUP_NAME} --zone-name ${ZONE_NAME} --name @
```

## Repair

### Check and update the DNS settings to ensure that the custom domain is correctly mapped to the web app's IP address.
```shell


#!/bin/bash



# Set variables

webapp_name=${WEBAPP_NAME}

custom_domain=${YOURDOMAIN}

resource_group_name=${RESOURCE_GROUP_NAME}

zone_name=${ZONE_NAME}







# Get web app IP address

webapp_ip=$(az webapp show --name $webapp_name --resource-group $resource_group_name --query "outboundIpAddresses" --output tsv | awk -F ',' '{print $NF}')



# Get DNS record for custom domain

dns_record=$(nslookup $custom_domain | grep "Address" | tail -1 | awk '{print $NF}')



# Check if DNS record matches web app IP address

if [ "$dns_record" == "$webapp_ip" ]; then

    echo "DNS is correctly mapped to web app IP address."

else

    # Update DNS record to web app IP address

    az network dns record-set a add-record --record-set-name @ --resource-group $resource_group_name --zone-name $zone_name --ipv4-address $webapp_ip

    az network dns record-set a remove-record --record-set-name @ --resource-group $resource_group_name --zone-name $zone_name --ipv4-address $dns_record

    echo "DNS record updated to web app IP address."

fi


```