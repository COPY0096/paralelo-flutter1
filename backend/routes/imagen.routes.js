const express = require('express');
const multer = require('multer');
const path = require('path');
const { subirImagen } = require('../controllers/imagenController');

const router = express.Router();



router.get('/imagenes', async (req, res) => {
  try {
    const [rows] = await pool.query('SELECT * FROM imagenes ORDER BY fecha_subida DESC');
    res.json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ mensaje: 'Error al obtener imágenes' });
  }
});

module.exports = router;
