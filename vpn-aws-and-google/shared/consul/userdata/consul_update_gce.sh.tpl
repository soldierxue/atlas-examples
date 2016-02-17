#!/bin/bash

set -e

FILE_FINAL=/etc/consul.d/consul.json
FILE_TMP=$FILE_FINAL.tmp

sudo sed -i -- "s/{{ region }}/${region}/g" $FILE_TMP
sudo sed -i -- "s/{{ atlas_token }}/${atlas_token}/g" $FILE_TMP
sudo sed -i -- "s/{{ atlas_username }}/${atlas_username}/g" $FILE_TMP
sudo sed -i -- "s/{{ atlas_environment }}/${atlas_environment}/g" $FILE_TMP
# Note: consul_bootstrap_expect isn't required for consul clients, only servers.
sudo sed -i -- "s/{{ consul_bootstrap_expect }}/${consul_bootstrap_expect}/g" $FILE_TMP

# Note: placeholders below replaced by bash, not the Terraform go template.
INSTANCE_ID=`hostname`
sudo sed -i -- "s/{{ instance_id }}/$INSTANCE_ID/g" $FILE_TMP
INSTANCE_ADDRESS=`curl -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/ip`
sudo sed -i -- "s/{{ local_ipv4 }}/$INSTANCE_ADDRESS/g" $FILE_TMP

sudo mv $FILE_TMP $FILE_FINAL
sudo service consul start || sudo service consul restart

echo "Consul environment updated."

exit 0
