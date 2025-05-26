package handlers

import (
	"context"
	"encoding/json"
	"os"

	"github.com/aws/aws-lambda-go/events"
	"github.com/dimaserbenyuk/API-Gateway/db"
	"github.com/dimaserbenyuk/API-Gateway/models"
	"github.com/dimaserbenyuk/API-Gateway/utils"
)

func CreateTodo(ctx context.Context, request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	var todo models.Todo
	err := json.Unmarshal([]byte(request.Body), &todo)
	if err != nil || todo.ID == "" || todo.Title == "" {
		return utils.BadRequest("Invalid input: ID and Title are required")
	}

	table := os.Getenv("TODOS_TABLE")
	err = db.PutTodo(ctx, table, &todo)
	if err != nil {
		return utils.InternalError(err)
	}

	return utils.CreatedResponse()
}
