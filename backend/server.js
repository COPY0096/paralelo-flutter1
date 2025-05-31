const express = require('express');
const app = express();
const cors = require('cors');
const authRoutes = require('./routes/authRoutes'); 
const productoRoutes = require('./routes/producto.routes'); 
const usuarioRoutes = require('./routes/usuario.routes');

app.use(cors());
app.use(express.json());

app.use('/api/auth', authRoutes); 
app.use('/api/productos', productoRoutes);
app.use('/api/usuarios', usuarioRoutes);

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en puerto ${PORT}`);
});
