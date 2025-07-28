// backend/controllers/authController.js

const mysql = require('mysql2');
const GitHubStrategy = require('passport-github2').Strategy;
const passport = require('passport');
const jwt = require('jsonwebtoken');
require('dotenv').config();

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '0096',
  database: 'flutter1'
});

passport.serializeUser((user, done) => done(null, user));
passport.deserializeUser((obj, done) => done(null, obj));

passport.use(new GitHubStrategy({
  clientID: process.env.GITHUB_CLIENT_ID,
  clientSecret: process.env.GITHUB_CLIENT_SECRET,
  callbackURL: "http://10.0.2.2:3000/auth/github/callback"
}, (accessToken, refreshToken, profile, done) => {
  const user = {
    id: profile.id,
    username: profile.username,
    displayName: profile.displayName || '',
    email: (profile.emails && profile.emails.length > 0) ? profile.emails[0].value : `${profile.username}@github.com`,
    avatar: profile.photos ? profile.photos[0].value : null,
    provider: 'github',
    rol: 'admin'
  };

  const checkUserQuery = 'SELECT * FROM usuarios WHERE username = ?';
  connection.query(checkUserQuery, [user.username], (err, results) => {
    if (err) return done(err);

    if (results.length > 0) {
      // Usuario ya existe - actualizar información de GitHub y asignar rol admin
      const updateQuery = 'UPDATE usuarios SET nombre = ?, correo = ?, rol = ? WHERE username = ?';
      connection.query(updateQuery, [user.displayName || user.username, user.email, 'admin', user.username], (updateErr) => {
        if (updateErr) console.error('Error updating user:', updateErr);
        
        // Retornar usuario actualizado con rol admin
        const updatedUser = {
          ...results[0],
          nombre: user.displayName || user.username,
          correo: user.email,
          rol: 'admin'
        };
        
        return done(null, updatedUser);
      });
    } else {
      // Crear el usuario con contraseña "1234" y rol admin por defecto
      const insertQuery = 'INSERT INTO usuarios (username, password, nombre, correo, rol) VALUES (?, ?, ?, ?, ?)';
      const values = [user.username, '1234', user.displayName || user.username, user.email, 'admin'];

      connection.query(insertQuery, values, (err2, result) => {
        if (err2) return done(err2);

        const newUser = {
          id: result.insertId,
          username: user.username,
          nombre: user.displayName || user.username,
          correo: user.email,
          rol: 'admin'
        };

        return done(null, newUser); // ✅ hasta aquí se registra
      });
    }
  });
}));

// Función para manejar el callback final de GitHub con JWT
const handleGitHubCallback = (req, res) => {
  const user = req.user;

  // Generar el token JWT con la info del usuario
  const token = jwt.sign(
    { id: user.id, username: user.username, rol: user.rol },
    process.env.JWT_SECRET || 'fallback_secret_key', // asegúrate de tener esto definido en .env
    { expiresIn: '1h' }
  );

  // Redirigir al esquema personalizado de tu app Flutter con el token
  res.redirect(`myapp://login-success?token=${token}`);
};

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
      
      // Generar JWT también para login regular
      const token = jwt.sign(
        { id: user.id, username: user.username, rol: user.rol },
        process.env.JWT_SECRET || 'fallback_secret_key',
        { expiresIn: '1h' }
      );

      return res.json({
        success: true,
        token: token,
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

module.exports = { loginUser, passport, handleGitHubCallback };
