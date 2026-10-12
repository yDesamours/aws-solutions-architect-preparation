aws s3api put-bucket-versioning --bucket "$BUCKET" \
  --versioning-configuration Status=Suspended

DRIFT_ID=$(aws cloudformation detect-stack-drift --stack-name "$STACK" \
  --query StackDriftDetectionId --output text)
sleep 20
aws cloudformation describe-stack-drift-detection-status \
  --stack-drift-detection-id "$DRIFT_ID" \
  --query '{Detection:DetectionStatus,Derive:StackDriftStatus}'

aws cloudformation describe-stack-resource-drifts --stack-name "$STACK" \
  --stack-resource-drift-status-filters MODIFIED \
  --query 'StackResourceDrifts[].PropertyDifferences[].{Propriete:PropertyPath,Attendu:ExpectedValue,Reel:ActualValue}' \
  --output table

aws s3api put-bucket-versioning --bucket "$BUCKET" \
  --versioning-configuration Status=Enabled

DRIFT_ID=$(aws cloudformation detect-stack-drift --stack-name "$STACK" \
  --query StackDriftDetectionId --output text)
sleep 20
aws cloudformation describe-stack-drift-detection-status \
  --stack-drift-detection-id "$DRIFT_ID" \
  --query '{Detection:DetectionStatus,Derive:StackDriftStatus}'


