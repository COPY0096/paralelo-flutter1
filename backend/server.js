const express = require('express');
const app = express();
const cors = require('cors');
const authRoutes = require('./routes/authRoutes'); // 👈 Login
const productoRoutes = require('./routes/producto.routes'); // 👈 Productos

app.use(cors());
app.use(express.json());

app.use('/api/auth', authRoutes); // 👈 Esta línea es CLAVE
app.use('/api/productos', productoRoutes);

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Servidor corriendo en puerto ${PORT}`);
});
