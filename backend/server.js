// backend/server.js

const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();

// Importar rutas existentes
const imagenRoutes    = require('./routes/imagen.routes');
const usuarioRoutes   = require('./routes/usuario.routes');
const productoRoutes  = require('./routes/producto.routes');
const authRoutes      = require('./routes/authRoutes');

// Importar nuevas rutas de Recursos Humanos
const salarioRoutes    = require('./routes/salario.routes');
const permisoRoutes    = require('./routes/permiso.routes');
const vacacionesRoutes = require('./routes/vacaciones.routes');

// Middleware
app.use(cors());
app.use(express.json());

// Carpeta de uploads para imágenes
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Rutas existentes
app.use('/api/imagenes', imagenRoutes);
app.use('/api/usuarios', usuarioRoutes);
app.use('/api/productos', productoRoutes);
app.use('/api/auth', authRoutes);

// Nuevas rutas de Recursos Humanos
app.use('/api/salarios', salarioRoutes);
app.use('/api/permisos', permisoRoutes);
app.use('/api/vacaciones', vacacionesRoutes);

// Levantar servidor
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en http://localhost:${PORT}`);
});

// const express = require('express');
// const cors = require('cors');
// const app = express();
// const path = require('path');

// const imagenRoutes = require('./routes/imagen.routes');
// const usuarioRoutes = require('./routes/usuario.routes');
// const productoRoutes = require('./routes/producto.routes');
// const authRoutes = require('./routes/authRoutes');

// // Middleware
// app.use(cors());
// app.use(express.json());
// app.use('/uploads', express.static(path.join(__dirname, 'uploads')));


// // Rutas
// app.use('/api/imagenes', imagenRoutes);
// app.use('/api/usuarios', usuarioRoutes);
// app.use('/api/productos', productoRoutes);
// app.use('/api/auth', authRoutes);

// const PORT = 3000;
// app.listen(PORT, () => {
//   console.log(`Servidor corriendo en http://localhost:${PORT}`);
// });