package db

import (
	"context"
	"fmt"
	"log"

	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/feature/dynamodb/attributevalue"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
	"github.com/dimaserbenyuk/API-Gateway/models"
)

var client *dynamodb.Client

func init() {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatalf("failed to load AWS config: %v", err)
	}
	client = dynamodb.NewFromConfig(cfg)
}

func ScanTodos(ctx context.Context, table string) ([]models.Todo, error) {
	if table == "" {
		return nil, fmt.Errorf("ScanTodos: table name is empty")
	}

	output, err := client.Scan(ctx, &dynamodb.ScanInput{
		TableName: &table,
	})
	if err != nil {
		log.Printf("ScanTodos error: %v", err)
		return nil, err
	}

	var todos []models.Todo
	if err := attributevalue.UnmarshalListOfMaps(output.Items, &todos); err != nil {
		log.Printf("UnmarshalListOfMaps error: %v", err)
		return nil, err
	}

	log.Printf("ScanTodos: found %d items", len(todos))
	return todos, nil
}

func PutTodo(ctx context.Context, table string, todo *models.Todo) error {
	if table == "" {
		return fmt.Errorf("PutTodo: table name is empty")
	}
	if todo == nil {
		return fmt.Errorf("PutTodo: todo is nil")
	}

	item, err := attributevalue.MarshalMap(todo)
	if err != nil {
		log.Printf("MarshalMap error: %v", err)
		return err
	}

	_, err = client.PutItem(ctx, &dynamodb.PutItemInput{
		TableName: &table,
		Item:      item,
		ReturnValues: types.ReturnValueNone,
	})
	if err != nil {
		log.Printf("PutItem error: %v", err)
		return err
	}

	log.Printf("PutTodo: inserted item with ID=%s", todo.ID)
	return nil
}
