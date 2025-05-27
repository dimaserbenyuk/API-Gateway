# API-Gateway
API-Gateway

openapi-generator version

7.13.0

openapi-generator generate -i openapi.yaml -g html2 -o docs

brew install openapi-generator

curl https://dedvnhvc0j.execute-api.us-east-1.amazonaws.com/dev/todos 

curl -X POST https://dedvnhvc0j.execute-api.us-east-1.amazonaws.com/dev/todos \
  -H "Content-Type: application/json" \
  -d '{"id": "3", "title": "tests"}'  

serverless deploy --stage prod

aws cognito-idp sign-up \
  --client-id ... \
  --username test@example.com \
  --password "StrongPass123" \
  --region us-east-1

aws cognito-idp admin-confirm-sign-up \
  --user-pool-id us-east-1_O62ufGQzq \
  --username test@example.com \
  --region us-east-1

 aws cognito-idp initiate-auth \
  --auth-flow USER_PASSWORD_AUTH \
  --client-id ... \
  --auth-parameters USERNAME=test@example.com,PASSWORD=StrongPass123 \
  --region us-east-1 | jq .

curl -X POST https://m2jpil6lv2.execute-api.us-east-1.amazonaws.com/todos \
  -H "Content-Type: application/json" \
  -H "Authorization: ....." \
  -d '{"id": "3", "title": "tests"}'