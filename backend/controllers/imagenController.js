const path = require('path');
const fs = require('fs');

const subirImagen = (req, res) => {
  if (!req.file) {
    return res.status(400).json({ error: 'No se subió ninguna imagen' });
  }

  const imagenUrl = `/uploads/${req.file.filename}`;
  res.status(200).json({ mensaje: 'Imagen subida con éxito', imagenUrl });
};

module.exports = { subirImagen };
