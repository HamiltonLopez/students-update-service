package services

import (
    "example.com/students-update-service/models"
    "example.com/students-update-service/repositories"
)

type StudentServiceInterface interface {
    UpdateStudent(student *models.Student) (*models.Student, error)
}

type StudentService struct {
    repo *repositories.StudentRepository
}

func NewStudentService(repo *repositories.StudentRepository) *StudentService {
    return &StudentService{repo}
}

func (s *StudentService) UpdateStudent(student *models.Student) (*models.Student, error) {
    return s.repo.UpdateStudent(student)
}

