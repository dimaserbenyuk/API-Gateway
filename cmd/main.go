package main

import (
	"context"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
	"github.com/dimaserbenyuk/API-Gateway/handlers"
)

func router(ctx context.Context, req events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	switch req.HTTPMethod {
	case "GET":
		return handlers.GetTodos(ctx, req)
	case "POST":
		return handlers.CreateTodo(ctx, req)
	default:
		return events.APIGatewayProxyResponse{StatusCode: 405}, nil
	}
}

func main() {
	os.Setenv("AWS_SDK_LOAD_CONFIG", "1")
	lambda.Start(router)
}
