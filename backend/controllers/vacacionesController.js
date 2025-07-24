// backend/controllers/vacacionesController.js

const mysql = require('mysql2');
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '0096',
  database: 'flutter1'
});

/**
 * GET /api/vacaciones
 * Opcional query param: ?usuario_id=#
 */
const getVacaciones = (req, res) => {
  const { usuario_id } = req.query;
  let sql = 'SELECT * FROM vacaciones';
  const params = [];

  if (usuario_id) {
    sql += ' WHERE usuario_id = ?';
    params.push(usuario_id);
  }

  connection.query(sql, params, (err, results) => {
    if (err) {
      console.error('DB error fetching vacaciones:', err);
      return res.status(500).json({ error: 'Error al obtener vacaciones' });
    }
    res.json(results);
  });
};

/**
 * POST /api/vacaciones
 * body: { usuario_id, fecha_inicio, fecha_fin, dias_aprobados?, comentario? }
 */
const createVacacion = (req, res) => {
  const { usuario_id, fecha_inicio, fecha_fin, dias_aprobados, comentario } = req.body;
  const sql = `
    INSERT INTO vacaciones
      (usuario_id, fecha_inicio, fecha_fin, dias_aprobados, comentario)
    VALUES (?, ?, ?, ?, ?)
  `;
  connection.query(
    sql,
    [usuario_id, fecha_inicio, fecha_fin, dias_aprobados || 0, comentario || null],
    (err, result) => {
      if (err) {
        console.error('DB error creating vacacion:', err);
        return res.status(500).json({ error: 'Error al crear solicitud de vacaciones' });
      }
      res.json({
        id: result.insertId,
        usuario_id,
        fecha_inicio,
        fecha_fin,
        dias_aprobados: dias_aprobados || 0,
        comentario: comentario || null,
        estado: 'solicitada'
      });
    }
  );
};

/**
 * PUT /api/vacaciones/:id
 * body: { fecha_inicio?, fecha_fin?, dias_aprobados?, comentario?, estado? }
 */
const updateVacacion = (req, res) => {
  const { id } = req.params;
  const { fecha_inicio, fecha_fin, dias_aprobados, comentario, estado } = req.body;
  const sql = `
    UPDATE vacaciones
    SET fecha_inicio = ?, fecha_fin = ?, dias_aprobados = ?, comentario = ?, estado = ?
    WHERE id = ?
  `;
  connection.query(
    sql,
    [fecha_inicio, fecha_fin, dias_aprobados, comentario, estado, id],
    (err) => {
      if (err) {
        console.error('DB error updating vacacion:', err);
        return res.status(500).json({ error: 'Error al actualizar solicitud de vacaciones' });
      }
      res.json({
        id: Number(id),
        fecha_inicio,
        fecha_fin,
        dias_aprobados,
        comentario,
        estado
      });
    }
  );
};

/**
 * DELETE /api/vacaciones/:id
 */
const deleteVacacion = (req, res) => {
  const { id } = req.params;
  const sql = 'DELETE FROM vacaciones WHERE id = ?';
  connection.query(sql, [id], (err) => {
    if (err) {
      console.error('DB error deleting vacacion:', err);
      return res.status(500).json({ error: 'Error al eliminar solicitud de vacaciones' });
    }
    res.json({ success: true });
  });
};

module.exports = {
  getVacaciones,
  createVacacion,
  updateVacacion,
  deleteVacacion
};
