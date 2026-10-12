aws cloudformation deploy \
  --stack-name "$STACK" \
  --template-file m1-v2.yaml \
  --tags $TAGS \
  --no-execute-changeset

CS=$(aws cloudformation list-change-sets --stack-name "$STACK" \
  --query "Summaries[?Status=='CREATE_COMPLETE'] | [0].ChangeSetName" --output text)
echo "$CS"

aws cloudformation describe-change-set --stack-name "$STACK" --change-set-name "$CS" \
  --query 'Changes[].ResourceChange.{Action:Action,Ressource:LogicalResourceId,Remplacement:Replacement}' \
  --output table

aws cloudformation execute-change-set --stack-name "$STACK" --change-set-name "$CS"

aws s3api get-bucket-lifecycle-configuration --bucket "$BUCKET" \
  --query 'Rules[].{Id:ID,Statut:Status}'

aws ssm get-parameter --name /saa-lab/dev/m1/bucket-name \
  --query Parameter.Value --output text

aws cloudformation describe-stacks --stack-name "$STACK" \
  --query "Stacks[0].Outputs[?OutputKey=='BucketName'].OutputValue" --output text
