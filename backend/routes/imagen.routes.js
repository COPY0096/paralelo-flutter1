const express = require('express');
const router = express.Router();
const multer = require('multer');
const path = require('path');
const mysql = require('mysql2');
const { subirImagen } = require('../controllers/imagenController');

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '0096',
  database: 'flutter1'
});

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname));
  }
});
const upload = multer({ storage });

// POST: Subir imagen
router.post('/upload', upload.single('imagen'), subirImagen);

// GET: Obtener imágenes
router.get('/', (req, res) => {
  connection.query('SELECT ruta FROM imagenes', (error, results) => {
    if (error) {
      console.error('Error al obtener imágenes:', error);
      return res.status(500).json({ mensaje: 'Error al obtener imágenes' });
    }
    res.json(results);
  });
});

module.exports = router;
