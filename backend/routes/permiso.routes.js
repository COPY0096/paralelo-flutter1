// backend/routes/permiso.routes.js

const express = require('express');
const router = express.Router();
const {
  getPermisos,
  createPermiso,
  updatePermiso,
  deletePermiso
} = require('../controllers/permisoController');

router.get('/', getPermisos);
router.post('/', createPermiso);
router.put('/:id', updatePermiso);
router.delete('/:id', deletePermiso);

module.exports = router;
