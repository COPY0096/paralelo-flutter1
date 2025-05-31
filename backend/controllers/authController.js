const mysql = require('mysql2');

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '0096',
  database: 'flutter1'
});

const loginUser = (req, res) => {
  const { username, password } = req.body;
  console.log('Login request received:', username, password); // 👈 Debug

  const sql = 'SELECT * FROM usuarios WHERE username = ? AND password = ?';
  connection.query(sql, [username, password], (err, results) => {
    if (err) {
      console.error('DB Error:', err);
      return res.status(500).json({ error: 'Error de servidor' });
    }

    if (results.length > 0) {
      return res.json({ success: true, user: results[0] });
    } else {
      return res.status(401).json({ success: false, message: 'Credenciales inválidas' });
    }
  });
};

module.exports = { loginUser };
