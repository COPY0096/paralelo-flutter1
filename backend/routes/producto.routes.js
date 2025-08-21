//backend/routes/producto.routes.js
const express = require('express');
const router = express.Router();
const {
  getProductos,
  getProductoById,
  createProducto,
  updateProducto,
  deleteProducto,
  venderProducto,
  reabastecerProducto,
  historialVentas,
  historialReabastecimientos,
  movimientosProducto
} = require('../controllers/productoController');

// Rutas de historial (deben ir ANTES de las rutas con parámetros)
router.get('/historial/ventas', historialVentas);
router.get('/historial/reabastecimientos', historialReabastecimientos);

// Rutas CRUD básicas
router.get('/', getProductos);
router.get('/:id', getProductoById);
router.post('/', createProducto);
router.put('/:id', updateProducto);
router.delete('/:id', deleteProducto);

// Rutas de operaciones de inventario
router.post('/:id/vender', venderProducto);
router.post('/:id/reabastecer', reabastecerProducto);

// Ruta para movimientos específicos de un producto
router.get('/:id/movimientos', movimientosProducto);

module.exports = router;
