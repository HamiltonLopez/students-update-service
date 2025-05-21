# Students Update Service

Servicio responsable de actualizar la información de estudiantes existentes en el sistema.

## Funcionalidad

Este servicio expone un endpoint PUT que permite actualizar los datos de un estudiante específico utilizando su identificador único.

## Especificaciones Técnicas

- **Puerto**: 8084 (interno), 30084 (NodePort)
- **Endpoint**: PUT `/students/{id}`
- **Runtime**: Go
- **Base de Datos**: MongoDB

## Estructura del Servicio

```
students-update-service/
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
├── src/
│   ├── main.go
│   ├── handlers/
│   ├── models/
│   └── config/
├── Dockerfile
└── README.md
```

## API Endpoint

### PUT /students/{id}

Actualiza la información de un estudiante específico.

#### URL Parameters
- `id`: ID único del estudiante (requerido)

#### Request Body
```json
{
    "name": "string",
    "age": number,
    "email": "string"
}
```

#### Response
```json
{
    "id": "string",
    "name": "string",
    "age": number,
    "email": "string",
    "updated_at": "timestamp"
}
```

#### Error Response
```json
{
    "error": "string",
    "message": "string"
}
```

## Configuración Kubernetes

### Deployment
- **Replicas**: 3
- **Imagen**: hamiltonlg/students-update-service:latest
- **Variables de Entorno**:
  - MONGO_URI: mongodb://mongo-service:27017

### Service
- **Tipo**: NodePort
- **Puerto**: 8084 -> 30084

## Despliegue

```bash
kubectl apply -f k8s/
```

## Verificación

1. Verificar el deployment:
```bash
kubectl get deployment students-update-deployment
```

2. Verificar los pods:
```bash
kubectl get pods -l app=students-update
```

3. Verificar el servicio:
```bash
kubectl get svc students-update-service
```

## Pruebas

### Actualizar un estudiante
```bash
curl -X PUT http://localhost:30084/students/12345 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Juan Pérez Actualizado",
    "age": 21,
    "email": "juan.nuevo@example.com"
  }'
```

## Logs

Ver logs de un pod específico:
```bash
kubectl logs -f <pod-name>
```

## Monitoreo

### Métricas Importantes
- Tiempo de respuesta del endpoint
- Tasa de éxito/error en actualizaciones
- Uso de recursos (CPU/Memoria)
- Latencia de operaciones en MongoDB

## Solución de Problemas

1. **Error de Conexión a MongoDB**:
   - Verificar la variable MONGO_URI
   - Comprobar conectividad con mongo-service
   - Revisar logs de MongoDB

2. **Estudiante No Encontrado**:
   - Verificar el formato del ID
   - Comprobar existencia en la base de datos
   - Revisar logs de la aplicación

3. **Validación de Datos**:
   - Verificar formato de los datos de entrada
   - Comprobar restricciones de campos
   - Revisar manejo de errores

4. **Pod en CrashLoopBackOff**:
   - Verificar logs del pod
   - Comprobar recursos asignados
   - Verificar configuración del deployment

## Optimización

1. **Validación**:
   - Implementar validación robusta de datos
   - Verificar integridad de campos
   - Manejar casos especiales

2. **Transacciones**:
   - Implementar operaciones atómicas
   - Manejar rollbacks en caso de error
   - Asegurar consistencia de datos

3. **Auditoría**:
   - Registrar cambios realizados
   - Mantener historial de actualizaciones
   - Implementar trazabilidad 