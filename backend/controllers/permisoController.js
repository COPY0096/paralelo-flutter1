// backend/controllers/permisoController.js

const mysql = require('mysql2');
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '0096',
  database: 'flutter1'
});

/**
 * GET /api/permisos
 * Opcional query param: ?usuario_id=#
 */
const getPermisos = (req, res) => {
  const { usuario_id } = req.query;
  let sql = 'SELECT * FROM permisos';
  const params = [];

  if (usuario_id) {
    sql += ' WHERE usuario_id = ?';
    params.push(usuario_id);
  }

  connection.query(sql, params, (err, results) => {
    if (err) {
      console.error('DB error fetching permisos:', err);
      return res.status(500).json({ error: 'Error al obtener permisos' });
    }
    res.json(results);
  });
};

/**
 * POST /api/permisos
 * body: { usuario_id, tipo_permiso, fecha_inicio, fecha_fin, razon }
 */
const createPermiso = (req, res) => {
  const { usuario_id, tipo_permiso, fecha_inicio, fecha_fin, razon } = req.body;
  const sql = `
    INSERT INTO permisos
      (usuario_id, tipo_permiso, fecha_inicio, fecha_fin, razon)
    VALUES (?, ?, ?, ?, ?)
  `;
  connection.query(
    sql,
    [usuario_id, tipo_permiso, fecha_inicio, fecha_fin, razon || null],
    (err, result) => {
      if (err) {
        console.error('DB error creating permiso:', err);
        return res.status(500).json({ error: 'Error al crear permiso' });
      }
      res.json({
        id: result.insertId,
        usuario_id,
        tipo_permiso,
        fecha_inicio,
        fecha_fin,
        razon,
        estado: 'pendiente'
      });
    }
  );
};

/**
 * PUT /api/permisos/:id
 * body: { tipo_permiso?, fecha_inicio?, fecha_fin?, razon?, estado? }
 */
const updatePermiso = (req, res) => {
  const { id } = req.params;
  const { tipo_permiso, fecha_inicio, fecha_fin, razon, estado } = req.body;
  const sql = `
    UPDATE permisos
    SET tipo_permiso = ?, fecha_inicio = ?, fecha_fin = ?, razon = ?, estado = ?
    WHERE id = ?
  `;
  connection.query(
    sql,
    [tipo_permiso, fecha_inicio, fecha_fin, razon, estado, id],
    (err) => {
      if (err) {
        console.error('DB error updating permiso:', err);
        return res.status(500).json({ error: 'Error al actualizar permiso' });
      }
      res.json({ 
        id: Number(id),
        tipo_permiso,
        fecha_inicio,
        fecha_fin,
        razon,
        estado
      });
    }
  );
};

/**
 * DELETE /api/permisos/:id
 */
const deletePermiso = (req, res) => {
  const { id } = req.params;
  const sql = 'DELETE FROM permisos WHERE id = ?';
  connection.query(sql, [id], (err) => {
    if (err) {
      console.error('DB error deleting permiso:', err);
      return res.status(500).json({ error: 'Error al eliminar permiso' });
    }
    res.json({ success: true });
  });
};

module.exports = {
  getPermisos,
  createPermiso,
  updatePermiso,
  deletePermiso
};
