

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