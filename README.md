# Students Update Service

Este servicio es parte del sistema de gestión de estudiantes y se encarga de actualizar la información de estudiantes existentes.

## Estructura del Servicio

```
students-update-service/
├── controllers/     # Controladores REST
├── models/         # Modelos de datos
├── repositories/   # Capa de acceso a datos
├── services/      # Lógica de negocio
├── k8s/           # Configuraciones de Kubernetes
│   ├── deployment.yaml
│   ├── service.yaml
│   └── ingress.yaml
└── test/          # Scripts de prueba
    └── test-update.sh
```

## Endpoints

### PUT /update/{id}
Actualiza la información de un estudiante existente.

**Parámetros de URL:**
- `id`: ID del estudiante (ObjectId)

**Request Body:**
```json
{
    "name": "string",
    "age": number,
    "email": "string"
}
```

**Response (200 OK):**
```json
{
    "id": "string",
    "name": "string",
    "age": number,
    "email": "string"
}
```

**Response (404 Not Found):**
```json
{
    "error": "Student not found"
}
```

## Configuración Kubernetes

### Deployment
El servicio se despliega con las siguientes especificaciones:
- Replicas: 1
- Puerto: 8080
- Imagen: students-update-service:latest

### Service
- Tipo: NodePort
- Puerto: 8080
- NodePort: 30084

### Ingress
- Path: /update
- Servicio: students-update-service
- Puerto: 8080

## Despliegue en Kubernetes

### 1. Aplicar configuraciones
```bash
# Crear el deployment
kubectl apply -f k8s/deployment.yaml

# Crear el service
kubectl apply -f k8s/service.yaml

# Crear el ingress
kubectl apply -f k8s/ingress.yaml
```

### 2. Verificar el despliegue
```bash
# Verificar el deployment
kubectl get deployment students-update-deployment
kubectl describe deployment students-update-deployment

# Verificar los pods
kubectl get pods -l app=students-update
kubectl describe pod -l app=students-update

# Verificar el service
kubectl get svc students-update-service
kubectl describe svc students-update-service

# Verificar el ingress
kubectl get ingress students-update-ingress
kubectl describe ingress students-update-ingress
```

### 3. Verificar logs
```bash
# Ver logs de los pods
kubectl logs -l app=students-update
```

### 4. Escalar el servicio
```bash
# Escalar a más réplicas si es necesario
kubectl scale deployment students-update-deployment --replicas=3
```

### 5. Actualizar el servicio
```bash
# Actualizar la imagen del servicio
kubectl set image deployment/students-update-deployment students-update=students-update-service:nueva-version
```

### 6. Eliminar recursos
```bash
# Si necesitas eliminar los recursos
kubectl delete -f k8s/ingress.yaml
kubectl delete -f k8s/service.yaml
kubectl delete -f k8s/deployment.yaml
```

## Pruebas

El servicio incluye un script de pruebas automatizadas (`test/test-update.sh`) que verifica:

1. Actualización exitosa de un estudiante
2. Manejo de datos inválidos
3. Actualización parcial de campos
4. Manejo de estudiante inexistente

Para ejecutar las pruebas:
```bash
./test/test-update.sh
```

También se puede ejecutar como parte de la suite completa de pruebas:
```bash
./test-all-services.sh
```

### Casos de Prueba

1. **Test 1:** Actualizar estudiante con datos válidos
   - Crea un estudiante de prueba
   - Actualiza sus datos
   - Verifica los cambios

2. **Test 2:** Intentar actualizar con datos inválidos
   - Envía datos con formato incorrecto
   - Verifica el manejo de errores

3. **Test 3:** Actualización parcial
   - Actualiza solo algunos campos
   - Verifica que los campos no actualizados se mantienen

4. **Test 4:** Actualizar estudiante inexistente
   - Intenta actualizar un ID que no existe
   - Verifica el mensaje de error apropiado

## Variables de Entorno

- `MONGODB_URI`: URI de conexión a MongoDB (default: "mongodb://mongo-service:27017")
- `DATABASE_NAME`: Nombre de la base de datos (default: "studentsdb")
- `COLLECTION_NAME`: Nombre de la colección (default: "students")

## Dependencias

- Go 1.19+
- MongoDB
- Kubernetes 1.19+
- Ingress NGINX Controller

## Consideraciones de Seguridad

1. Validación de datos de entrada
2. Verificación de permisos
3. Sanitización de datos
4. Manejo seguro de errores
5. Validación de formato de ID

## Monitoreo y Logs

- Endpoint de health check: `/health`
- Logs en formato JSON
- Métricas de rendimiento:
  - Tiempo de respuesta
  - Tasa de éxito/error en actualizaciones
  - Campos más frecuentemente actualizados

## Solución de Problemas

1. Verificar la conexión con MongoDB
2. Comprobar los logs del pod
3. Validar la configuración del Ingress
4. Verificar el estado del servicio en Kubernetes
5. Revisar el formato de los datos de actualización 