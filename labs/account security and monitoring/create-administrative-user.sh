LAB_USER="lab-admin"
OWNER="yvelt"

# update the password policy for iam users
aws iam update-account-password-policy \
  --minimum-password-length 14 \
  --require-symbols --require-numbers \
  --require-uppercase-characters --require-lowercase-characters \
  --allow-users-to-change-password

# create a group
aws iam create-group --group-name lab-admins

# attach the administrative access policy to the group
aws iam attach-group-policy \
    --group-name lab-admins \
    --policy-arn arn:aws:iam::aws:policy/AdministratorAccess

# create a user
aws iam create-user --user-name "$LAB_USER" \
  --tags Key=Project,Value=saa-lab Key=Lesson,Value=l0 Key=Owner,Value="$OWNER" Key=Environment,Value=lab

# add the user to the administrative group
aws iam add-user-to-group --user-name "$LAB_USER" --group-name lab-admins

# group users
aws iam get-group --group-name lab-admins --query 'Users[].UserName'

# list group policy
aws iam list-attached-group-policies --group-name lab-admins