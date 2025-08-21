// backend/controllers/pagosSalarioController.js
const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: 'localhost',
  user: 'root',
  password: '0096',
  database: 'flutter1',
  waitForConnections: true,
  connectionLimit: 10
});

// GET /api/pagos-salarios?empleado_id=#
async function getPagos(req, res) {
  try {
    const { empleado_id } = req.query;
    let sql = `
      SELECT p.*, e.nombre AS empleado
      FROM pagos_salarios p
      JOIN empleados e ON e.id = p.empleado_id
      ORDER BY p.creado_en DESC
    `;
    const params = [];

    if (empleado_id) {
      sql = `
        SELECT p.*, e.nombre AS empleado
        FROM pagos_salarios p
        JOIN empleados e ON e.id = p.empleado_id
        WHERE p.empleado_id = ?
        ORDER BY p.creado_en DESC
      `;
      params.push(empleado_id);
    }

    const [rows] = await pool.query(sql, params);
    res.json(rows);
  } catch (err) {
    console.error('getPagos error:', err);
    res.status(500).json({ error: 'Error al obtener pagos de salario' });
  }
}

// POST /api/pagos-salarios
// body: { empleado_id, monto, periodo_inicio?, periodo_fin?, fecha_pago?, metodo?, comentarios? }
async function createPago(req, res) {
  try {
    const { empleado_id, monto, periodo_inicio, periodo_fin, fecha_pago, metodo, comentarios } = req.body;

    if (!empleado_id || !monto) {
      return res.status(400).json({ mensaje: 'empleado_id y monto son requeridos' });
    }

    const [emp] = await pool.query('SELECT id, salario FROM empleados WHERE id = ?', [empleado_id]);
    if (emp.length === 0) return res.status(404).json({ mensaje: 'Empleado no encontrado' });

    const _monto = Number(monto);
    if (Number.isNaN(_monto) || _monto <= 0) {
      return res.status(400).json({ mensaje: 'monto inválido' });
    }

    const [r] = await pool.query(
      `INSERT INTO pagos_salarios (empleado_id, monto, periodo_inicio, periodo_fin, fecha_pago, metodo, comentarios)
       VALUES (?, ?, ?, ?, COALESCE(?, CURRENT_DATE), ?, ?)`,
      [
        empleado_id,
        _monto,
        periodo_inicio || null,
        periodo_fin || null,
        fecha_pago || null,
        metodo || 'transferencia',
        comentarios || null
      ]
    );

    res.status(201).json({
      id: r.insertId,
      empleado_id,
      monto: _monto,
      periodo_inicio: periodo_inicio || null,
      periodo_fin: periodo_fin || null,
      fecha_pago: fecha_pago || new Date().toISOString().slice(0,10),
      metodo: metodo || 'transferencia',
      comentarios: comentarios || null
    });
  } catch (err) {
    console.error('createPago error:', err);
    res.status(500).json({ error: 'Error al crear pago de salario' });
  }
}

module.exports = { getPagos, createPago };
