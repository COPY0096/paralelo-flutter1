const mysql = require('mysql2');

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '0096',
  database: 'flutter1'
});

const getUsuarios = (req, res) => {
  const sql = 'SELECT * FROM usuarios';
  connection.query(sql, (err, results) => {
    if (err) return res.status(500).json({ error: 'Error al obtener usuarios' });
    res.json(results);
  });
};

const createUsuario = (req, res) => {
  const { username, nombre, correo, rol, password } = req.body;
  const sql = 'INSERT INTO usuarios (username, nombre, correo, rol, password) VALUES (?, ?, ?, ?, ?)';
  connection.query(sql, [username, nombre, correo, rol, password], (err, result) => {
    if (err) return res.status(500).json({ error: 'Error al crear usuario', err });
    res.json({ id: result.insertId, username, nombre, correo, rol });
  });
};

const updateUsuario = (req, res) => {
  const { id } = req.params;
  const { username, nombre, correo, rol, password } = req.body;
  const sql = 'UPDATE usuarios SET username = ?, nombre = ?, correo = ?, rol = ?, password = ? WHERE id = ?';
  connection.query(sql, [username, nombre, correo, rol, password, id], (err) => {
    if (err) return res.status(500).json({ error: 'Error al actualizar usuario' });
    res.json({ id, username, nombre, correo, rol });
  });
};

const deleteUsuario = (req, res) => {
  const { id } = req.params;
  const sql = 'DELETE FROM usuarios WHERE id = ?';
  connection.query(sql, [id], (err) => {
    if (err) return res.status(500).json({ error: 'Error al eliminar usuario' });
    res.json({ success: true });
  });
};

module.exports = {
  getUsuarios,
  createUsuario,
  updateUsuario,
  deleteUsuario
};
