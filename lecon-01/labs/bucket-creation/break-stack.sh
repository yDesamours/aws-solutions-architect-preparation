aws cloudformation deploy \
  --stack-name "$STACK" \
  --template-file m1-v3.yaml \
  --tags $TAGS

  aws cloudformation describe-stacks --stack-name "$STACK" \
  --query 'Stacks[0].StackStatus' --output text

aws cloudformation describe-stack-events --stack-name "$STACK" --max-items 20 \
  --query "StackEvents[?ResourceStatus=='CREATE_FAILED' || ResourceStatus=='UPDATE_FAILED'].{Ressource:LogicalResourceId,Statut:ResourceStatus,Raison:ResourceStatusReason}" \
  --output table

aws s3api get-bucket-policy --bucket "$BUCKET"
aws ssm get-parameter --name /saa-lab/dev/m1/bucket-name --query Parameter.Value --output text