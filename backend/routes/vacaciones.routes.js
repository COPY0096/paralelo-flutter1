//backend/routes/vacaciones.routes.js
const express = require('express');
const router = express.Router();
const { getVacaciones, createVacacion } = require('../controllers/vacacionesController');

router.get('/', getVacaciones);
router.post('/', createVacacion);

module.exports = router;
