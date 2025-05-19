package repositories

import (
    "context"
    "go.mongodb.org/mongo-driver/bson"
    "go.mongodb.org/mongo-driver/mongo"
    "go.mongodb.org/mongo-driver/mongo/options"
    "example.com/students-update-service/models"
    "log"
    "os"  
)

type StudentRepository struct {
    collection *mongo.Collection
}

func NewStudentRepository() *StudentRepository {
    mongoURI := os.Getenv("MONGO_URI")
    if mongoURI == "" {
        log.Fatal("MONGO_URI not set in environment")
    }

    clientOptions := options.Client().ApplyURI(mongoURI)
    client, err := mongo.Connect(context.TODO(), clientOptions)
    if err != nil {
        log.Fatal(err)
    }

    collection := client.Database("school").Collection("students")
    return &StudentRepository{collection}
}

func (repo *StudentRepository) UpdateStudent(student *models.Student) (*models.Student, error) {
    filter := bson.M{"_id": student.ID}
    update := bson.M{"$set": student}

    _, err := repo.collection.UpdateOne(context.TODO(), filter, update)
    if err != nil {
        return nil, err
    }

    return student, nil
}

