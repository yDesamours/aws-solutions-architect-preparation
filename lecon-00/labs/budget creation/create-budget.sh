# get accound id
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)

# create the budget
aws budgets create-budget \
  --account-id "$ACCOUNT_ID" \
  --budget file://budget.json \
  --notifications-with-subscribers file://notifications.json

# verification
aws budgets describe-budget --account-id "$ACCOUNT_ID" --budget-name lab-mensuel --query 'Budget.{Nom:BudgetName,Limite:BudgetLimit,Credits:CostTypes.IncludeCredit}'
aws budgets describe-notifications-for-budget --account-id "$ACCOUNT_ID" --budget-name lab-mensuel