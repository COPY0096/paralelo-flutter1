const express = require('express');
const multer = require('multer');
const path = require('path');
const { subirImagen } = require('../controllers/imagenController');

const router = express.Router();

// Configuración de almacenamiento con multer
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function (req, file, cb) {
    const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9);
    cb(null, uniqueSuffix + path.extname(file.originalname));
  }
});

const upload = multer({ storage });

router.post('/subir', upload.single('imagen'), subirImagen);

module.exports = router;
