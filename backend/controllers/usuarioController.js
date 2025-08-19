// backend/controllers/usuarioController.js
const mysql = require('mysql2');

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '0096',
  database: 'flutter1'
});

// Promisificar la conexión para usar async/await
const db = connection.promise();

const getUsuarios = async (req, res) => {
  try {
    const [results] = await db.query('SELECT * FROM usuarios');
    res.json(results);
  } catch (err) {
    console.error('Error al obtener usuarios:', err);
    res.status(500).json({ error: 'Error al obtener usuarios' });
  }
};

const createUsuario = async (req, res) => {
  try {
    const { username, nombre, correo, rol, password } = req.body;
    const [result] = await db.query(
      'INSERT INTO usuarios (username, nombre, correo, rol, password) VALUES (?, ?, ?, ?, ?)',
      [username, nombre, correo, rol, password]
    );
    res.json({ id: result.insertId, username, nombre, correo, rol });
  } catch (err) {
    console.error('Error al crear usuario:', err);
    res.status(500).json({ error: 'Error al crear usuario' });
  }
};

const updateUsuario = (req, res) => {
  const id = req.params.id;
  const { username, nombre, correo, rol } = req.body;

  if (!username || !nombre || !correo || !rol) {
    return res.status(400).json({ mensaje: 'Faltan campos requeridos' });
  }

  const sql = 'UPDATE usuarios SET username = ?, nombre = ?, correo = ?, rol = ? WHERE id = ?';
  connection.query(sql, [username, nombre, correo, rol, id], (err, result) => {
    if (err) {
      console.error('Error al actualizar usuario:', err);
      return res.status(500).json({ mensaje: 'Error al actualizar usuario' });
    }

    if (result.affectedRows === 0) {
      return res.status(404).json({ mensaje: 'Usuario no encontrado' });
    }

    res.json({ mensaje: 'Usuario actualizado correctamente' });
  });
};

const deleteUsuario = async (req, res) => {
  try {
    const { id } = req.params;
    
    // Verificar que el usuario exista antes de eliminar
    const [existe] = await db.query('SELECT * FROM usuarios WHERE id = ?', [id]);
    if (existe.length === 0) {
      return res.status(404).json({ mensaje: 'Usuario no encontrado' });
    }

    await db.query('DELETE FROM usuarios WHERE id = ?', [id]);
    res.json({ success: true, mensaje: 'Usuario eliminado correctamente' });
  } catch (err) {
    console.error('Error al eliminar usuario:', err);
    res.status(500).json({ error: 'Error al eliminar usuario' });
  }
};

const changePassword = async (req, res) => {
  try {
    const id = req.params.id;
    const { claveActual, nuevaClave } = req.body;

    // Validar que los campos requeridos estén presentes
    if (!claveActual || !nuevaClave) {
      return res.status(400).json({ 
        mensaje: 'La clave actual y nueva clave son requeridas' 
      });
    }

    // Validar longitud de la nueva contraseña
    if (nuevaClave.length < 6) {
      return res.status(400).json({ 
        mensaje: 'La nueva contraseña debe tener al menos 6 caracteres' 
      });
    }

    // Verificar que la nueva contraseña sea diferente
    if (claveActual === nuevaClave) {
      return res.status(400).json({ 
        mensaje: 'La nueva contraseña debe ser diferente a la actual' 
      });
    }

    // Verificar que el usuario exista y obtener su contraseña actual
    const [usuario] = await db.query('SELECT * FROM usuarios WHERE id = ?', [id]);

    if (usuario.length === 0) {
      return res.status(404).json({ mensaje: 'Usuario no encontrado' });
    }

    // Verificar que la contraseña actual sea correcta
    if (usuario[0].password !== claveActual) {
      return res.status(401).json({ mensaje: 'Contraseña actual incorrecta' });
    }

    // Actualizar la contraseña
    await db.query('UPDATE usuarios SET password = ? WHERE id = ?', [nuevaClave, id]);

    res.json({ 
      success: true, 
      mensaje: 'Contraseña actualizada correctamente' 
    });
  } catch (error) {
    console.error('Error al cambiar la contraseña:', error);
    res.status(500).json({ error: 'Error interno del servidor' });
  }
};

const recuperarClave = async (req, res) => {
  const { username, nuevaClave } = req.body;

  if (!username || !nuevaClave) {
    return res.status(400).json({ mensaje: "Faltan datos" });
  }

  try {
    // Validar longitud de la nueva contraseña
    if (nuevaClave.length < 6) {
      return res.status(400).json({ mensaje: "La nueva contraseña debe tener al menos 6 caracteres" });
    }

    const [usuario] = await db.query("SELECT * FROM usuarios WHERE username = ?", [username]);

    if (usuario.length === 0) {
      return res.status(404).json({ mensaje: "Usuario no encontrado" });
    }

    // Actualizar directamente la contraseña sin hashear (como en el resto del sistema)
    await db.query("UPDATE usuarios SET password = ? WHERE username = ?", [nuevaClave, username]);

    res.json({ 
      success: true,
      mensaje: "Contraseña actualizada correctamente" 
    });
  } catch (error) {
    console.error('Error al recuperar clave:', error);
    res.status(500).json({ mensaje: "Error en el servidor", error: error.message });
  }
};

module.exports = {
  getUsuarios,
  createUsuario,
  updateUsuario,
  deleteUsuario,
  changePassword,
  recuperarClave,
};
