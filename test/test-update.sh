#!/bin/bash

# Colores para la salida
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# URLs de los servicios
SERVICE_URL="http://${KUBE_IP}:30084"
CREATE_URL="http://${KUBE_IP}:30081"
DELETE_URL="http://${KUBE_IP}:30085"

echo "Probando Students Update Service..."
echo "=================================="

# Crear un estudiante para las pruebas
echo -e "\nCreando estudiante de prueba..."
response=$(curl -s -X POST \
  "${CREATE_URL}/students" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Estudiante Original",
    "age": 20,
    "email": "original@example.com"
  }')

if [[ $response == *"id"* ]]; then
    STUDENT_ID=$(echo $response | grep -o '"id":"[^"]*' | cut -d'"' -f4)
    echo "ID del estudiante creado: $STUDENT_ID"
else
    echo -e "${RED}No se pudo crear el estudiante de prueba${NC}"
    exit 1
fi

# Test 1: Actualizar estudiante con datos válidos
echo -e "\nTest 1: Actualizar estudiante con datos válidos"
response=$(curl -s -X PUT \
  "${SERVICE_URL}/students/${STUDENT_ID}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Estudiante Actualizado",
    "age": 21,
    "email": "actualizado@example.com"
  }')

if [[ $response == *"Estudiante Actualizado"* ]]; then
    echo -e "${GREEN}✓ Test 1 exitoso: Estudiante actualizado correctamente${NC}"
else
    echo -e "${RED}✗ Test 1 fallido: No se pudo actualizar el estudiante${NC}"
    echo "Respuesta: $response"
fi

# Test 2: Intentar actualizar con datos inválidos
echo -e "\nTest 2: Actualizar con datos inválidos"
response=$(curl -s -X PUT \
  "${SERVICE_URL}/students/${STUDENT_ID}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "",
    "age": -1,
    "email": "invalid-email"
  }')

if [[ $response == *"error"* ]]; then
    echo -e "${GREEN}✓ Test 2 exitoso: El servicio rechazó correctamente los datos inválidos${NC}"
else
    echo -e "${RED}✗ Test 2 fallido: El servicio aceptó datos inválidos${NC}"
fi

# Test 3: Intentar actualizar estudiante inexistente
echo -e "\nTest 3: Actualizar estudiante inexistente"
response=$(curl -s -X PUT \
  "${SERVICE_URL}/students/507f1f77bcf86cd799439011" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test",
    "age": 25,
    "email": "test@example.com"
  }')

if [[ $response == *"error"* && $response == *"not found"* ]]; then
    echo -e "${GREEN}✓ Test 3 exitoso: El servicio manejó correctamente el ID inexistente${NC}"
else
    echo -e "${RED}✗ Test 3 fallido: El servicio no manejó correctamente el ID inexistente${NC}"
fi

# Test 4: Actualizar solo algunos campos
echo -e "\nTest 4: Actualizar solo algunos campos"
response=$(curl -s -X PUT \
  "${SERVICE_URL}/students/${STUDENT_ID}" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Nombre Parcialmente Actualizado"
  }')

if [[ $response == *"Nombre Parcialmente Actualizado"* ]]; then
    echo -e "${GREEN}✓ Test 4 exitoso: Actualización parcial realizada correctamente${NC}"
else
    echo -e "${RED}✗ Test 4 fallido: La actualización parcial no funcionó${NC}"
fi

echo -e "\nPruebas completadas!"

# Limpiar: Eliminar el estudiante de prueba
echo -e "\nLimpiando datos de prueba..."
curl -s -X DELETE "${DELETE_URL}/students/${STUDENT_ID}" > /dev/null
echo "Estudiante de prueba eliminado" 