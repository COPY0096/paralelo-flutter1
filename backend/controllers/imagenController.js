


const mysql = require('mysql2/promise');

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '0096',
  database: 'flutter1'
});




exports.subirImagen = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ mensaje: 'No se subió ninguna imagen' });
    }
    const rutaImagen = `/uploads/${req.file.filename}`;
    await db.query('INSERT INTO imagenes (ruta) VALUES (?)', [rutaImagen]);
    res.json({ mensaje: 'Imagen subida correctamente', ruta: rutaImagen });
  } catch (error) {
    console.error(error);
    res.status(500).json({ mensaje: 'Error al subir imagen' });
  }
};


