// backend/server.js

require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');
const session = require('express-session');
const passport = require('./config/passport'); // <== aquí lo traes

const app = express();
const usuariosRoutes = require('./routes/usuario.routes');

// Importar rutas existentes
const imagenRoutes    = require('./routes/imagen.routes');
const usuarioRoutes   = require('./routes/usuario.routes');
const productoRoutes  = require('./routes/producto.routes');
const authRoutes      = require('./routes/authRoutes');

// Importar nuevas rutas de Recursos Humanos
const salarioRoutes    = require('./routes/salario.routes');
const permisoRoutes    = require('./routes/permiso.routes');
const vacacionesRoutes = require('./routes/vacaciones.routes');

// Importar rutas de GitHub Auth
const githubAuthRoutes = require('./routes/githubAuth.routes');

// Middleware
app.use(cors());
app.use(express.json()); // importante para leer JSON

// Configuración de sesiones para autenticación con GitHub
app.use(session({
  secret: process.env.SESSION_SECRET || 'smartcontrolsecret',
  resave: false,
  saveUninitialized: false
}));

// Inicializar Passport
app.use(passport.initialize());
app.use(passport.session());

// Carpeta de uploads para imágenes
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Rutas existentes
app.use('/api/imagenes', imagenRoutes);
app.use('/api/usuarios', usuarioRoutes);
app.use('/api/productos', productoRoutes);
app.use('/api/auth', authRoutes);
app.use('/api', usuariosRoutes); // Esto activa rutas como /api/usuarios/1/cambiar-clave

// Nuevas rutas de Recursos Humanos
app.use('/api/salarios', salarioRoutes);
app.use('/api/permisos', permisoRoutes);
app.use('/api/vacaciones', vacacionesRoutes);

// Rutas de autenticación con GitHub
app.use('/auth', githubAuthRoutes);

// Arranque del servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en puerto ${PORT}`);
  console.log(`Servidor en http://localhost:${PORT}`);
});