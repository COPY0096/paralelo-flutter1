// backend/controllers/salarioController.js

const mysql = require('mysql2');
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '0096',
  database: 'flutter1'
});

/**
 * GET /api/salarios
 * Opcional query param: ?usuario_id=#
 */
const getSalarios = (req, res) => {
  const { usuario_id } = req.query;
  let sql = 'SELECT * FROM salarios';
  const params = [];

  if (usuario_id) {
    sql += ' WHERE usuario_id = ?';
    params.push(usuario_id);
  }

  connection.query(sql, params, (err, results) => {
    if (err) {
      console.error('DB error fetching salarios:', err);
      return res.status(500).json({ error: 'Error al obtener salarios' });
    }
    res.json(results);
  });
};

/**
 * POST /api/salarios
 * body: { usuario_id, salario, fecha_inicio, fecha_fin?, comentarios? }
 */
const createSalario = (req, res) => {
  const { usuario_id, salario, fecha_inicio, fecha_fin, comentarios } = req.body;
  const sql = `
    INSERT INTO salarios
      (usuario_id, salario, fecha_inicio, fecha_fin, comentarios)
    VALUES (?, ?, ?, ?, ?)
  `;
  connection.query(
    sql,
    [usuario_id, salario, fecha_inicio, fecha_fin || null, comentarios || null],
    (err, result) => {
      if (err) {
        console.error('DB error creating salario:', err);
        return res.status(500).json({ error: 'Error al crear salario' });
      }
      res.json({
        id: result.insertId,
        usuario_id,
        salario,
        fecha_inicio,
        fecha_fin,
        comentarios
      });
    }
  );
};

/**
 * PUT /api/salarios/:id
 * body: { salario, fecha_inicio, fecha_fin?, comentarios? }
 */
const updateSalario = (req, res) => {
  const { id } = req.params;
  const { salario, fecha_inicio, fecha_fin, comentarios } = req.body;
  const sql = `
    UPDATE salarios
    SET salario = ?, fecha_inicio = ?, fecha_fin = ?, comentarios = ?
    WHERE id = ?
  `;
  connection.query(
    sql,
    [salario, fecha_inicio, fecha_fin || null, comentarios || null, id],
    (err) => {
      if (err) {
        console.error('DB error updating salario:', err);
        return res.status(500).json({ error: 'Error al actualizar salario' });
      }
      res.json({ id: Number(id), salario, fecha_inicio, fecha_fin, comentarios });
    }
  );
};

/**
 * DELETE /api/salarios/:id
 */
const deleteSalario = (req, res) => {
  const { id } = req.params;
  const sql = 'DELETE FROM salarios WHERE id = ?';
  connection.query(sql, [id], (err) => {
    if (err) {
      console.error('DB error deleting salario:', err);
      return res.status(500).json({ error: 'Error al eliminar salario' });
    }
    res.json({ success: true });
  });
};

module.exports = {
  getSalarios,
  createSalario,
  updateSalario,
  deleteSalario
};
