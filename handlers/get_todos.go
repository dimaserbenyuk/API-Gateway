package handlers

import (
	"context"
	"encoding/json"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/dimaserbenyuk/API-Gateway/db"
	"github.com/dimaserbenyuk/API-Gateway/utils"
)

func GetTodos(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	table := os.Getenv("TODOS_TABLE")
	todos, err := db.ScanTodos(ctx, table)
	if err != nil {
		return utils.InternalError(err)
	}

	body, _ := json.Marshal(todos)
	return utils.OkResponse(body)
}
