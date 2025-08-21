//backend/routes/pagosSalario.routes.js
const express = require('express');
const router = express.Router();
const { getPagos, createPago } = require('../controllers/pagosSalarioController');

router.get('/', getPagos);
router.post('/', createPago);

module.exports = router;
