#!/usr/bin/sh

timedatectl set-timezone Australia/Sydney

sleep 3

REGION="ap-southeast-2"

INSTANCE_ID=`ec2-metadata  --instance-id | cut -d' ' -f2`
PUBLIC_IPV4=`ec2-metadata  --public-ipv4 | cut -d' ' -f2`
UNIQ_ID=`ec2-metadata --tags --region "$REGION" | grep uniq_id | xargs | cut -d' ' -f2` 
UNIQ_PREFIX=`ec2-metadata --tags --region "$REGION" | grep uniq_prefix | xargs | cut -d' ' -f2` 

USERNAME=`aws ssm get-parameter --name "/$UNIQ_PREFIX/username" --region "$REGION" | jq -r '.Parameter.Value'`
PASSWORD=`aws ssm get-parameter --name "/$UNIQ_PREFIX/cred" --region "$REGION" | jq -r '.Parameter.Value'`

aws ssm put-parameter --name "/$UNIQ_PREFIX/ip" --overwrite --value "$PUBLIC_IPV4" --region "$REGION"

useradd $USERNAME
usermod -a -G wheel $USERNAME
echo "$USERNAME:$PASSWORD" | chpasswd

sleep 1

rm /usr/bin/ec2-metadata
