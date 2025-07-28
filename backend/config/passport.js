const passport = require('passport');
const GitHubStrategy = require('passport-github2').Strategy;
const jwt = require('jsonwebtoken');
const mysql = require('mysql2');
require('dotenv').config();

// Conexión a la base de datos
const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '0096',
  database: 'flutter1'
});

passport.serializeUser((user, done) => done(null, user));
passport.deserializeUser((obj, done) => done(null, obj));

// Función para buscar o crear usuario
const findOrCreateUser = async (profile) => {
  const githubUsername = profile.username || '';
  const displayName = profile.displayName || githubUsername;
  const correo = profile.emails?.[0]?.value || `${githubUsername}@github.com`;

  // Buscar si el usuario ya existe por username o correo
  const checkUserQuery = 'SELECT * FROM usuarios WHERE username = ? OR correo = ?';
  
  try {
    const [rows] = await db.promise().query(checkUserQuery, [githubUsername, correo]);

    if (rows.length > 0) {
      // Usuario ya registrado - actualizar información
      const existingUser = rows[0];
      const updateQuery = 'UPDATE usuarios SET nombre = ?, correo = ?, rol = ? WHERE id = ?';
      
      await db.promise().query(updateQuery, [displayName, correo, 'admin', existingUser.id]);
      
      return {
        id: existingUser.id,
        username: githubUsername,
        nombre: displayName,
        correo: correo,
        rol: 'admin'
      };
    } else {
      // Insertar nuevo usuario con rol admin
      const insertQuery = 'INSERT INTO usuarios (username, password, nombre, correo, rol) VALUES (?, ?, ?, ?, ?)';
      const values = [githubUsername, '1234', displayName, correo, 'admin'];

      const [result] = await db.promise().query(insertQuery, values);
      
      return {
        id: result.insertId,
        username: githubUsername,
        nombre: displayName,
        correo: correo,
        rol: 'admin'
      };
    }
  } catch (error) {
    throw error;
  }
};

passport.use(new GitHubStrategy({
    clientID: process.env.GITHUB_CLIENT_ID,
    clientSecret: process.env.GITHUB_CLIENT_SECRET,
    callbackURL: process.env.GITHUB_CALLBACK_URL || "http://10.0.2.2:3000/auth/github/callback",
  },
  async (accessToken, refreshToken, profile, done) => {
    try {
      // Buscar o crear el usuario en tu base de datos
      const user = await findOrCreateUser(profile); // Asegúrate que devuelve { id, username, rol }

      // Genera token y continúa
      const token = jwt.sign(
        { id: user.id, username: user.username, rol: user.rol }, 
        process.env.JWT_SECRET || 'fallback_secret'
      );
      user.token = token;
      
      return done(null, user); // Esto es crucial
    } catch (error) {
      return done(error, null);
    }
  }
));

module.exports = passport;