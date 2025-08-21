// backend/controllers/vacacionesController.js
const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '0096',
  database: 'flutter1',
  waitForConnections: true,
  connectionLimit: 10
});

// GET /api/vacaciones?empleado_id=#
async function getVacaciones(req, res) {
  try {
    const { empleado_id } = req.query;
    let sql = `
      SELECT v.*, e.nombre AS empleado
      FROM vacaciones v
      JOIN empleados e ON e.id = v.empleado_id
      ORDER BY v.creado_en DESC
    `;
    const params = [];

    if (empleado_id) {
      sql = `
        SELECT v.*, e.nombre AS empleado
        FROM vacaciones v
        JOIN empleados e ON e.id = v.empleado_id
        WHERE v.empleado_id = ?
        ORDER BY v.creado_en DESC
      `;
      params.push(empleado_id);
    }

    const [rows] = await pool.query(sql, params);
    res.json(rows);
  } catch (err) {
    console.error('getVacaciones error:', err);
    res.status(500).json({ error: 'Error al obtener vacaciones' });
  }
}

// POST /api/vacaciones
// body: { empleado_id, fecha_inicio (YYYY-MM-DD), fecha_fin (YYYY-MM-DD), motivo?, estado? }
async function createVacacion(req, res) {
  try {
    const { empleado_id, fecha_inicio, fecha_fin, motivo, estado } = req.body;

    if (!empleado_id || !fecha_inicio || !fecha_fin) {
      return res.status(400).json({ mensaje: 'empleado_id, fecha_inicio y fecha_fin son requeridos' });
    }

    const [emp] = await pool.query('SELECT id FROM empleados WHERE id = ?', [empleado_id]);
    if (emp.length === 0) return res.status(404).json({ mensaje: 'Empleado no encontrado' });

    const [r] = await pool.query(
      `INSERT INTO vacaciones (empleado_id, fecha_inicio, fecha_fin, dias, motivo, estado)
       VALUES (?, ?, ?, DATEDIFF(?, ?)+1, ?, ?)`,
      [empleado_id, fecha_inicio, fecha_fin, fecha_fin, fecha_inicio, motivo || null, estado || 'aprobada']
    );

    res.status(201).json({
      id: r.insertId,
      empleado_id,
      fecha_inicio,
      fecha_fin,
      motivo: motivo || null,
      estado: estado || 'aprobada'
    });
  } catch (err) {
    console.error('createVacacion error:', err);
    res.status(500).json({ error: 'Error al crear vacación' });
  }
}

module.exports = { getVacaciones, createVacacion };
