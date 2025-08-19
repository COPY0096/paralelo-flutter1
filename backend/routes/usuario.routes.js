// backend/routes/usuario.routes.js 
const express = require('express');
const router = express.Router();
const usuarioController = require('../controllers/usuarioController');
const {
  obtenerUsuarios,
  obtenerUsuarioPorId,
  crearUsuario,
  actualizarUsuario,
  eliminarUsuario,
  cambiarClave,
  recuperarClave // ✅ Asegúrate de importar esto
} = require('../controllers/usuarioController');

// Rutas básicas CRUD
router.get('/', usuarioController.getUsuarios);
router.post('/', usuarioController.createUsuario);
router.put('/:id', usuarioController.updateUsuario);
router.delete('/:id', usuarioController.deleteUsuario);

// Rutas específicas para usuarios
router.put('/usuarios/:id', usuarioController.updateUsuario);

// PUT /api/usuarios/:id/password - Cambiar contraseña con verificación de clave actual
router.put('/:id/password', usuarioController.changePassword);

// PUT /api/usuarios/:id/cambiar-clave - Cambiar contraseña (reutilizando changePassword)
router.put('/:id/cambiar-clave', usuarioController.changePassword);

router.post('/recuperar-clave', recuperarClave);


module.exports = router;
