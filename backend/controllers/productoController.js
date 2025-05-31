const mysql = require('mysql2');

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '0096',
  database: 'flutter1'
});

// GET /api/productos
const getProductos = (req, res) => {
  const sql = 'SELECT * FROM productos';
  connection.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: 'Error al obtener productos' });
    res.json(results);
  });
};

// GET /api/productos/:id
const getProductoById = (req, res) => {
  const { id } = req.params;
  const sql = 'SELECT * FROM productos WHERE id = ?';
  connection.query(sql, [id], (err, results) => {
    if (err) return res.status(500).json({ error: 'Error al obtener producto' });
    if (results.length === 0) return res.status(404).json({ message: 'Producto no encontrado' });
    res.json(results[0]);
  });
};

// POST /api/productos
const createProducto = (req, res) => {
  const { nombre, precio, descripcion } = req.body;
  const sql = 'INSERT INTO productos (nombre, precio, descripcion) VALUES (?, ?, ?)';
  connection.query(sql, [nombre, precio, descripcion], (err, result) => {
    if (err) return res.status(500).json({ error: 'Error al crear producto' });
    res.status(201).json({ message: 'Producto creado', id: result.insertId });
  });
};

// PUT /api/productos/:id
const updateProducto = (req, res) => {
  const { id } = req.params;
  const { nombre, precio, descripcion } = req.body;
  const sql = 'UPDATE productos SET nombre = ?, precio = ?, descripcion = ? WHERE id = ?';
  connection.query(sql, [nombre, precio, descripcion, id], (err) => {
    if (err) return res.status(500).json({ error: 'Error al actualizar producto' });
    res.json({ message: 'Producto actualizado' });
  });
};

// DELETE /api/productos/:id
const deleteProducto = (req, res) => {
  const { id } = req.params;
  const sql = 'DELETE FROM productos WHERE id = ?';
  connection.query(sql, [id], (err) => {
    if (err) return res.status(500).json({ error: 'Error al eliminar producto' });
    res.json({ message: 'Producto eliminado' });
  });
};

module.exports = {
  getProductos,
  getProductoById,
  createProducto,
  updateProducto,
  deleteProducto
};
