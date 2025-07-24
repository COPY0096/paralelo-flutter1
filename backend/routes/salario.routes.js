// backend/routes/salario.routes.js

const express = require('express');
const router = express.Router();
const {
  getSalarios,
  createSalario,
  updateSalario,
  deleteSalario
} = require('../controllers/salarioController');

router.get('/', getSalarios);
router.post('/', createSalario);
router.put('/:id', updateSalario);
router.delete('/:id', deleteSalario);

module.exports = router;
