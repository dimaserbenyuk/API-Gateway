# API-Gateway
API-Gateway

openapi-generator version

7.13.0

openapi-generator generate -i openapi.yaml -g html2 -o docs

brew install openapi-generator

curl https://yyn0razr5j.execute-api.us-east-1.amazonaws.com/dev/todos 

curl -X POST https://yyn0razr5j.execute-api.us-east-1.amazonaws.com/dev/todos \
  -H "Content-Type: application/json" \
  -d '{"id": "3", "title": "tests"}'  