export AWS_PROFILE=lab
export AWS_REGION=us-east-1
export STACK=saa-m1-fondations

# Nombre de Régions activées pour le compte
aws ec2 describe-regions --query 'length(Regions)'

# Régions à activation manuelle (opt-in) qui ne sont pas activées
aws ec2 describe-regions --all-regions \
  --query 'Regions[?OptInStatus==`not-opted-in`].RegionName' --output text

# AZ de us-east-1 : nom propre au compte et ID physique
aws ec2 describe-availability-zones \
  --filters Name=zone-type,Values=availability-zone \
  --query 'AvailabilityZones[].{Nom:ZoneName,ID:ZoneId,Etat:State}' --output table

# local zone attaches a la region
aws ec2 describe-availability-zones --all-availability-zones \
  --filters Name=zone-type,Values=local-zone \
  --query 'AvailabilityZones[].{Nom:ZoneName,Groupe:GroupName,OptIn:OptInStatus}' --output table