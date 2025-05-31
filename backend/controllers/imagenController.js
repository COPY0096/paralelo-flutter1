const multer = require('multer');
const path = require('path');
const fs = require('fs');


const mysql = require('mysql2');

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '0096',
  database: 'flutter1'
});
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/'); // carpeta donde guardas las imágenes
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname)); // nombre único
  }
});

const upload = multer({ storage });

const subirImagen = async (req, res) => {
  try {
    if (!req.file) return res.status(400).json({ mensaje: 'No se subió archivo' });

    const imagenUrl = `/uploads/${req.file.filename}`;

    // Guarda info en la base de datos
    const sql = 'INSERT INTO imagenes (ruta) VALUES (?)';
    await pool.query(sql, [imagenUrl]);

    return res.status(200).json({ mensaje: 'Imagen subida con éxito', imagenUrl });
  } catch (error) {
    console.error(error);
    return res.status(500).json({ mensaje: 'Error al subir imagen' });
  }
};

module.exports = { upload, subirImagen };
