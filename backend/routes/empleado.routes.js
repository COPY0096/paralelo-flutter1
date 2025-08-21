// backend/routes/empleado.routes.js
const express = require('express');
const router = express.Router();
const empleadoController = require('../controllers/empleadoController');

// GET /api/empleados → lista todos los empleados (versión simplificada)
router.get('/', empleadoController.getAllEmpleados);

// POST /api/empleados → agregar empleado (versión simplificada)
router.post('/', empleadoController.createEmpleado);

module.exports = router;
