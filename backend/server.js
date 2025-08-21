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
const salarioRoutes    = require('./routes/pagosSalario.routes');
const permisoRoutes    = require('./routes/permiso.routes');
const vacacionesRoutes = require('./routes/vacaciones.routes');
const pagosSalarioRoutes = require('./routes/pagosSalario.routes');

// Importar rutas de empleados
const empleadoRoutes = require('./routes/empleado.routes');

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

// Rutas para empleados
app.use('/api/empleados', empleadoRoutes);

// Nuevas rutas de Recursos Humanos
app.use('/api/salarios', pagosSalarioRoutes);
app.use('/api/permisos', permisoRoutes);
app.use('/api/vacaciones', vacacionesRoutes);
app.use('/api/pagos-salarios', pagosSalarioRoutes);

// Rutas de autenticación con GitHub
app.use('/auth', githubAuthRoutes);

// Arranque del servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Servidor corriendo en puerto ${PORT}`);
  console.log(`🌐 Servidor en http://localhost:${PORT}`);
  console.log(`\n📋 Rutas disponibles:`);
  
  // Rutas de Productos
  console.log(`\n📦 PRODUCTOS:`);
  console.log(`  • GET    /api/productos`);
  console.log(`  • GET    /api/productos/:id`);
  console.log(`  • POST   /api/productos`);
  console.log(`  • PUT    /api/productos/:id`);
  console.log(`  • DELETE /api/productos/:id`);
  console.log(`  • POST   /api/productos/:id/vender`);
  console.log(`  • POST   /api/productos/:id/reabastecer`);
  console.log(`  • GET    /api/productos/historial/ventas`);
  console.log(`  • GET    /api/productos/historial/reabastecimientos`);
  
  // Rutas de Empleados
  console.log(`\n👥 EMPLEADOS:`);
  console.log(`  • GET    /api/empleados`);
  console.log(`  • GET    /api/empleados/:id`);
  console.log(`  • POST   /api/empleados`);
  console.log(`  • PUT    /api/empleados/:id`);
  console.log(`  • DELETE /api/empleados/:id`);
  
  // Rutas de Recursos Humanos
  console.log(`\n🏖️  VACACIONES:`);
  console.log(`  • GET    /api/vacaciones`);
  console.log(`  • POST   /api/vacaciones`);
  console.log(`  • PUT    /api/vacaciones/:id`);
  console.log(`  • DELETE /api/vacaciones/:id`);
  
  console.log(`\n💰 PAGOS DE SALARIOS:`);
  console.log(`  • GET    /api/pagos-salarios`);
  console.log(`  • POST   /api/pagos-salarios`);
  console.log(`  • GET    /api/pagos-salarios/:id`);
  console.log(`  • PUT    /api/pagos-salarios/:id`);
  
  console.log(`\n📝 PERMISOS:`);
  console.log(`  • GET    /api/permisos`);
  console.log(`  • POST   /api/permisos`);
  console.log(`  • PUT    /api/permisos/:id`);
  console.log(`  • DELETE /api/permisos/:id`);
  
  console.log(`\n💼 SALARIOS:`);
  console.log(`  • GET    /api/salarios`);
  console.log(`  • POST   /api/salarios`);
  console.log(`  • PUT    /api/salarios/:id`);
  
  // Rutas de Usuarios y Auth
  console.log(`\n👤 USUARIOS & AUTH:`);
  console.log(`  • GET    /api/usuarios`);
  console.log(`  • POST   /api/usuarios`);
  console.log(`  • POST   /api/auth/login`);
  console.log(`  • POST   /api/auth/logout`);
  console.log(`  • GET    /auth/github`);
  
  // Rutas de Imágenes
  console.log(`\n🖼️  IMÁGENES:`);
  console.log(`  • POST   /api/imagenes/upload`);
  console.log(`  • GET    /uploads/:filename`);
  
  console.log(`\n✅ Sistema de gestión integral activo`);
  console.log(`🔧 Modo: ${process.env.NODE_ENV || 'development'}`);
});