package controllers

import (
    "encoding/json"
    "net/http"
    "github.com/gorilla/mux"
    "example.com/students-update-service/models"
    "example.com/students-update-service/services"
    "go.mongodb.org/mongo-driver/bson/primitive"
)

type StudentController struct {
    Service *services.StudentService
}

func NewStudentController(service *services.StudentService) *StudentController {
    return &StudentController{
        Service: service,
    }
}

func (c *StudentController) UpdateStudent(w http.ResponseWriter, r *http.Request) {
    vars := mux.Vars(r)
    id := vars["id"]

    var student models.Student
    err := json.NewDecoder(r.Body).Decode(&student)
    if err != nil {
        http.Error(w, "Datos inválidos", http.StatusBadRequest)
        return
    }

    // Convertimos el ID a ObjectID y lo asignamos al struct
    student.ID, err = primitive.ObjectIDFromHex(id)
    if err != nil {
        http.Error(w, "ID inválido", http.StatusBadRequest)
        return
    }

    updatedStudent, err := c.Service.UpdateStudent(&student)
    if err != nil {
        http.Error(w, "Error al actualizar estudiante", http.StatusInternalServerError)
        return
    }

    w.Header().Set("Content-Type", "application/json")
    w.WriteHeader(http.StatusOK)
    json.NewEncoder(w).Encode(map[string]interface{}{
        "message": "Estudiante actualizado correctamente",
        "student": updatedStudent,
    })
}

