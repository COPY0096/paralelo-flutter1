// backend/controllers/empleadoController.js
const mysql = require('mysql2');

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '0096',
  database: 'flutter1'
});

// Promisificar la conexión para usar async/await
const db = connection.promise();

// Obtener todos los empleados
const getAllEmpleados = async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT e.id, e.nombre, e.cedula, e.cargo, e.salario,
             u.correo, u.rol
      FROM empleados e
      LEFT JOIN usuarios u ON e.usuario_id = u.id
    `);
    res.json(rows);
  } catch (err) {
    console.error('Error al obtener empleados:', err);
    res.status(500).json({ error: err.message });
  }
};

// Obtener empleados con datos completos (método original)
const getEmpleados = async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT e.id, e.nombre, e.cedula, e.cargo, e.salario,
             u.correo, u.rol
      FROM empleados e
      LEFT JOIN usuarios u ON e.usuario_id = u.id
    `);
    res.json(rows);
  } catch (err) {
    console.error('Error al obtener empleados:', err);
    res.status(500).json({ error: 'Error al obtener empleados' });
  }
};

// Obtener empleado por ID
const getEmpleadoById = async (req, res) => {
  try {
    const { id } = req.params;
    const [rows] = await db.query(`
      SELECT e.id, e.nombre, e.cedula, e.cargo, e.salario,
             u.correo, u.rol
      FROM empleados e
      LEFT JOIN usuarios u ON e.usuario_id = u.id
      WHERE e.id = ?
    `, [id]);

    if (rows.length === 0) {
      return res.status(404).json({ mensaje: 'Empleado no encontrado' });
    }

    res.json(rows[0]);
  } catch (err) {
    console.error('Error al obtener empleado:', err);
    res.status(500).json({ error: 'Error al obtener empleado' });
  }
};

// Crear empleado (versión simplificada)
const createEmpleado = async (req, res) => {
  try {
    const { nombre, cedula, cargo, salario, correo, password, rol } = req.body;

    // Validaciones básicas
    if (!nombre || !cedula) {
      return res.status(400).json({ mensaje: 'Nombre y cédula son obligatorios' });
    }

    let usuarioId = null;
    
    // Crear usuario si se proporcionan los datos
    if (correo && password && rol) {
      // Validar rol
      if (!['admin', 'operador', 'invitado'].includes(rol)) {
        return res.status(400).json({ error: 'Rol inválido. Debe ser: admin, operador o invitado' });
      }

      const [userResult] = await db.query(
        'INSERT INTO usuarios (username, nombre, correo, password, rol) VALUES (?, ?, ?, ?, ?)',
        [nombre.toLowerCase().replace(/\s+/g, ''), nombre, correo, password, rol]
      );
      usuarioId = userResult.insertId;
    }

    // Crear empleado
    const [result] = await db.query(
      'INSERT INTO empleados (nombre, cedula, cargo, salario, usuario_id) VALUES (?, ?, ?, ?, ?)',
      [nombre, cedula, cargo || null, salario || 0, usuarioId]
    );

    res.status(201).json({ 
      id: result.insertId, 
      nombre, 
      cedula, 
      cargo, 
      salario, 
      correo, 
      rol,
      mensaje: 'Empleado creado con éxito'
    });
  } catch (err) {
    console.error('Error al crear empleado:', err);
    res.status(500).json({ error: err.message });
  }
};

// Crear empleado (versión completa con objeto usuario)
const createEmpleadoCompleto = async (req, res) => {
  try {
    const { nombre, cedula, correo, cargo, salario, usuario } = req.body;
    let usuario_id = null;

    // Validaciones básicas
    if (!nombre || !cedula) {
      return res.status(400).json({ mensaje: 'Nombre y cédula son obligatorios' });
    }

    // Crear usuario si se pasa en la request
    if (usuario) {
      const { username, password, rol } = usuario;

      if (!username || !password || !rol) {
        return res.status(400).json({ error: 'Username, password y rol son obligatorios para crear usuario' });
      }

      if (!['admin', 'operador', 'invitado'].includes(rol)) {
        return res.status(400).json({ error: 'Rol inválido. Debe ser: admin, operador o invitado' });
      }

      const [userResult] = await db.query(
        'INSERT INTO usuarios (username, nombre, correo, rol, password) VALUES (?, ?, ?, ?, ?)',
        [username, nombre, correo || null, rol, password]
      );
      usuario_id = userResult.insertId;
    }

    // Crear empleado
    const [empleadoResult] = await db.query(
      'INSERT INTO empleados (nombre, cedula, correo, cargo, salario, usuario_id) VALUES (?, ?, ?, ?, ?, ?)',
      [
        nombre, 
        cedula, 
        correo || null, 
        cargo || null, 
        salario || 0, 
        usuario_id
      ]
    );

    res.status(201).json({ 
      id: empleadoResult.insertId,
      nombre,
      cedula,
      correo,
      cargo,
      salario,
      usuario_id,
      mensaje: 'Empleado creado con éxito'
    });
  } catch (err) {
    console.error('Error al crear empleado:', err);
    res.status(500).json({ error: 'Error al crear empleado' });
  }
};

// Actualizar un empleado (versión mejorada)
const updateEmpleado = async (req, res) => {
  try {
    const { id } = req.params;
    const { nombre, cedula, cargo, salario, correo, password, rol } = req.body;

    // Verificar que el empleado existe
    const [exists] = await db.query('SELECT * FROM empleados WHERE id = ?', [id]);
    if (exists.length === 0) {
      return res.status(404).json({ mensaje: 'Empleado no encontrado' });
    }

    const empleado = exists[0];

    // Actualizar usuario si existe y se proporcionan datos
    if (empleado.usuario_id && (correo || password || rol)) {
      const updateUserFields = [];
      const updateUserValues = [];

      if (correo) {
        updateUserFields.push('correo = ?');
        updateUserValues.push(correo);
      }
      if (password) {
        updateUserFields.push('password = ?');
        updateUserValues.push(password);
      }
      if (rol) {
        if (!['admin', 'operador', 'invitado'].includes(rol)) {
          return res.status(400).json({ error: 'Rol inválido. Debe ser: admin, operador o invitado' });
        }
        updateUserFields.push('rol = ?');
        updateUserValues.push(rol);
      }

      if (updateUserFields.length > 0) {
        updateUserValues.push(empleado.usuario_id);
        await db.query(
          `UPDATE usuarios SET ${updateUserFields.join(', ')} WHERE id = ?`,
          updateUserValues
        );
      }
    }

    // Actualizar empleado
    const [result] = await db.query(`
      UPDATE empleados 
      SET nombre = ?, cedula = ?, cargo = ?, salario = ?
      WHERE id = ?
    `, [
      nombre, 
      cedula, 
      cargo || null, 
      salario || 0, 
      id
    ]);

    res.json({ 
      id: Number(id),
      nombre, 
      cedula, 
      cargo, 
      salario,
      message: 'Empleado actualizado correctamente',
      affectedRows: result.affectedRows 
    });
  } catch (err) {
    console.error('Error al actualizar empleado:', err);
    res.status(500).json({ error: 'Error al actualizar empleado' });
  }
};

// Eliminar un empleado
const deleteEmpleado = async (req, res) => {
  try {
    const { id } = req.params;
    
    // Verificar que el empleado existe
    const [exists] = await db.query('SELECT id FROM empleados WHERE id = ?', [id]);
    if (exists.length === 0) {
      return res.status(404).json({ mensaje: 'Empleado no encontrado' });
    }

    const [result] = await db.query('DELETE FROM empleados WHERE id = ?', [id]);
    
    res.json({ 
      success: true,
      message: 'Empleado eliminado correctamente',
      affectedRows: result.affectedRows
    });
  } catch (err) {
    console.error('Error al eliminar empleado:', err);
    res.status(500).json({ error: 'Error al eliminar empleado' });
  }
};

module.exports = {
  getAllEmpleados,
  getEmpleados,
  getEmpleadoById,
  createEmpleado,
  createEmpleadoCompleto,
  updateEmpleado,
  deleteEmpleado
};
