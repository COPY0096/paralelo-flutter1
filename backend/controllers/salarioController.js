// backend/controllers/salarioController.js
const mysql = require('mysql2');

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '0096',
  database: 'flutter1'
});

// Promisificar la conexión para usar async/await
const db = connection.promise();

/**
 * GET /api/salarios
 * Opcional query param: ?usuario_id=#
 */
const getSalarios = async (req, res) => {
  try {
    const { usuario_id } = req.query;
    let sql = `
      SELECT s.*, u.nombre, u.username 
      FROM salarios s 
      LEFT JOIN usuarios u ON s.usuario_id = u.id
    `;
    const params = [];

    if (usuario_id) {
      sql += ' WHERE s.usuario_id = ?';
      params.push(usuario_id);
    }

    sql += ' ORDER BY s.fecha_inicio DESC';

    const [results] = await db.query(sql, params);
    res.json(results);
  } catch (err) {
    console.error('Error al obtener salarios:', err);
    res.status(500).json({ error: 'Error al obtener salarios' });
  }
};

// Obtener historial de salarios de un usuario
const getSalariosByUsuario = async (req, res) => {
  try {
    const { usuarioId } = req.params;
    const [rows] = await db.query(`
      SELECT s.*, u.nombre, u.username 
      FROM salarios s
      LEFT JOIN usuarios u ON s.usuario_id = u.id
      WHERE s.usuario_id = ?
      ORDER BY s.fecha_inicio DESC
    `, [usuarioId]);
    res.json(rows);
  } catch (error) {
    console.error('Error al obtener salarios:', error);
    res.status(500).json({ error: 'Error al obtener salarios' });
  }
};

// Obtener salario actual de un usuario
const getSalarioActual = async (req, res) => {
  try {
    const { usuarioId } = req.params;
    const [rows] = await db.query(`
      SELECT s.*, u.nombre, u.username 
      FROM salarios s
      LEFT JOIN usuarios u ON s.usuario_id = u.id
      WHERE s.usuario_id = ? 
        AND (s.fecha_fin IS NULL OR s.fecha_fin >= CURDATE())
      ORDER BY s.fecha_inicio DESC
      LIMIT 1
    `, [usuarioId]);
    
    if (rows.length === 0) {
      return res.status(404).json({ mensaje: 'No se encontró salario activo para este usuario' });
    }
    
    res.json(rows[0]);
  } catch (error) {
    console.error('Error al obtener salario actual:', error);
    res.status(500).json({ error: 'Error al obtener salario actual' });
  }
};

// Crear nuevo registro de salario
const createSalario = async (req, res) => {
  try {
    const { usuario_id, salario, fecha_inicio, fecha_fin, comentarios } = req.body;

    // Validaciones básicas
    if (!usuario_id || !salario || !fecha_inicio) {
      return res.status(400).json({ 
        mensaje: 'Usuario ID, salario y fecha de inicio son obligatorios' 
      });
    }

    const [result] = await db.query(`
      INSERT INTO salarios (usuario_id, salario, fecha_inicio, fecha_fin, comentarios)
      VALUES (?, ?, ?, ?, ?)
    `, [
      usuario_id, 
      salario, 
      fecha_inicio, 
      fecha_fin || null, 
      comentarios || null
    ]);

    res.status(201).json({ 
      id: result.insertId, 
      usuario_id, 
      salario, 
      fecha_inicio, 
      fecha_fin, 
      comentarios,
      mensaje: 'Salario creado con éxito'
    });
  } catch (error) {
    console.error('Error al crear salario:', error);
    res.status(500).json({ error: 'Error al crear salario' });
  }
};

// Actualizar registro de salario
const updateSalario = async (req, res) => {
  try {
    const { id } = req.params;
    const { salario, fecha_inicio, fecha_fin, comentarios } = req.body;

    // Verificar que el salario existe
    const [exists] = await db.query('SELECT id FROM salarios WHERE id = ?', [id]);
    if (exists.length === 0) {
      return res.status(404).json({ mensaje: 'Salario no encontrado' });
    }

    const [result] = await db.query(`
      UPDATE salarios
      SET salario = ?, fecha_inicio = ?, fecha_fin = ?, comentarios = ?
      WHERE id = ?
    `, [
      salario, 
      fecha_inicio, 
      fecha_fin || null, 
      comentarios || null, 
      id
    ]);

    res.json({ 
      id: Number(id), 
      salario, 
      fecha_inicio, 
      fecha_fin, 
      comentarios,
      message: 'Salario actualizado correctamente',
      affectedRows: result.affectedRows
    });
  } catch (error) {
    console.error('Error al actualizar salario:', error);
    res.status(500).json({ error: 'Error al actualizar salario' });
  }
};

// Eliminar registro de salario
const deleteSalario = async (req, res) => {
  try {
    const { id } = req.params;
    
    // Verificar que el salario existe
    const [exists] = await db.query('SELECT id FROM salarios WHERE id = ?', [id]);
    if (exists.length === 0) {
      return res.status(404).json({ mensaje: 'Salario no encontrado' });
    }

    const [result] = await db.query('DELETE FROM salarios WHERE id = ?', [id]);
    
    res.json({ 
      success: true,
      message: 'Salario eliminado correctamente',
      affectedRows: result.affectedRows
    });
  } catch (error) {
    console.error('Error al eliminar salario:', error);
    res.status(500).json({ error: 'Error al eliminar salario' });
  }
};

module.exports = {
  getSalarios,
  getSalariosByUsuario,
  getSalarioActual,
  createSalario,
  updateSalario,
  deleteSalario
};
