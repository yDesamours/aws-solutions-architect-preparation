echo "facture test - version 1" > note.txt
aws s3 cp note.txt "s3://$BUCKET/note.txt"
echo "facture test - version 2" > note.txt
aws s3 cp note.txt "s3://$BUCKET/note.txt"

aws s3api list-object-versions --bucket "$BUCKET" \
  --query 'Versions[].{Cle:Key,Version:VersionId,Actuelle:IsLatest}' --output table

aws cloudformation delete-stack --stack-name "$STACK"
aws cloudformation wait stack-delete-complete --stack-name "$STACK"

aws cloudformation describe-stacks --stack-name "$STACK" \
  --query 'Stacks[0].StackStatus' --output text

aws cloudformation describe-stack-events --stack-name "$STACK" --max-items 10 \
  --query "StackEvents[?ResourceStatus=='DELETE_FAILED'].{Ressource:LogicalResourceId,Raison:ResourceStatusReason}" \
  --output table

aws ssm get-parameter --name /saa-lab/dev/m1/bucket-name 2>&1 | tail -1

aws s3api list-object-versions --bucket "$BUCKET" \
  --query '{Objects: [Versions, DeleteMarkers][][].{Key: Key, VersionId: VersionId}, Quiet: `true`}' \
  --output json > a-supprimer.json
cat a-supprimer.json

aws s3api delete-objects --bucket "$BUCKET" --delete file://a-supprimer.json
aws s3api list-object-versions --bucket "$BUCKET" --query '[Versions, DeleteMarkers]'

aws cloudformation delete-stack --stack-name "$STACK"
aws cloudformation wait stack-delete-complete --stack-name "$STACK" && echo "stack supprimé"

aws cloudformation describe-stacks --stack-name "$STACK" 2>&1 | tail -1
aws s3api head-bucket --bucket "$BUCKET" 2>&1 | tail -1