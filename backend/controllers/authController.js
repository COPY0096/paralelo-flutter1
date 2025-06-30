// backend/controllers/authController.js

const mysql = require('mysql2');

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '0096',
  database: 'flutter1'
});

const loginUser = (req, res) => {
  const { username, password } = req.body;
  console.log('Login request received:', username);

  const sql = 'SELECT id, username, nombre, correo, rol FROM usuarios WHERE username = ? AND password = ?';
  connection.query(sql, [username, password], (err, results) => {
    if (err) {
      console.error('DB Error:', err);
      return res.status(500).json({ error: 'Error de servidor' });
    }

    if (results.length > 0) {
      const user = results[0];
      // Enviar sólo los campos necesarios, SIN la contraseña
      return res.json({
        success: true,
        user: {
          id: user.id,
          username: user.username,
          nombre: user.nombre,
          correo: user.correo,
          rol: user.rol
        }
      });
    } else {
      return res.status(401).json({ success: false, message: 'Credenciales inválidas' });
    }
  });
};

module.exports = { loginUser };



// const mysql = require('mysql2');

// const connection = mysql.createConnection({
//   host: 'localhost',
//   user: 'root',
//   password: '0096',
//   database: 'flutter1'
// });

// const loginUser = (req, res) => {
//   const { username, password } = req.body;
//   console.log('Login request received:', username, password); // 👈 Debug

//   const sql = 'SELECT * FROM usuarios WHERE username = ? AND password = ?';
//   connection.query(sql, [username, password], (err, results) => {
//     if (err) {
//       console.error('DB Error:', err);
//       return res.status(500).json({ error: 'Error de servidor' });
//     }

//     if (results.length > 0) {
//       return res.json({ success: true, user: results[0] });
//     } else {
//       return res.status(401).json({ success: false, message: 'Credenciales inválidas' });
//     }
//   });
// };

// module.exports = { loginUser };
