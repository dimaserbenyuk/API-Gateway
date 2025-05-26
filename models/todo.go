package models

type Todo struct {
	ID    string `json:"id" dynamodbav:"id"`
	Title string `json:"title" dynamodbav:"title"`
}
