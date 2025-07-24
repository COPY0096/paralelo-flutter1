// backend/routes/vacaciones.routes.js

const express = require('express');
const router = express.Router();
const {
  getVacaciones,
  createVacacion,
  updateVacacion,
  deleteVacacion
} = require('../controllers/vacacionesController');

router.get('/', getVacaciones);
router.post('/', createVacacion);
router.put('/:id', updateVacacion);
router.delete('/:id', deleteVacacion);

module.exports = router;
