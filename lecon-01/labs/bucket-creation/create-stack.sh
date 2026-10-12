export OWNER="yvelt"
export STACK=saa-m1-fondations 
export TAGS="Project=saa-lab Lesson=l1 Owner=$OWNER Environment=lab"

aws cloudformation validate-template --template-body file://M1-v1.yaml

aws cloudformation deploy \
  --stack-name "$STACK" \
  --template-file m1-v1.yaml \
  --tags $TAGS

aws cloudformation describe-stacks --stack-name "$STACK" \
  --query 'Stacks[0].{Statut:StackStatus,Sorties:Outputs}'

aws cloudformation describe-stack-resources --stack-name "$STACK" \
  --query 'StackResources[].{Logique:LogicalResourceId,Physique:PhysicalResourceId,Type:ResourceType}' \
  --output table

export BUCKET=$(aws cloudformation describe-stacks --stack-name "$STACK" \
  --query "Stacks[0].Outputs[?OutputKey=='BucketName'].OutputValue" --output text)

echo "$BUCKET"

aws s3api get-bucket-versioning --bucket "$BUCKET"
aws s3api get-public-access-block --bucket "$BUCKET"
aws s3api get-bucket-encryption --bucket "$BUCKET" \
  --query 'ServerSideEncryptionConfiguration.Rules[0].ApplyServerSideEncryptionByDefault'
aws s3api get-bucket-tagging --bucket "$BUCKET"