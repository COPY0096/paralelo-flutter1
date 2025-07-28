//githubAuth.routes.js

const express = require('express');
const passport = require('passport');
const jwt = require('jsonwebtoken');

const router = express.Router();

// ✅ Estas rutas ya estarán bajo el prefijo '/auth' desde server.js
router.get('/github', passport.authenticate('github', { scope: ['user:email'] }));

router.get('/github/callback', 
  passport.authenticate('github', { failureRedirect: '/login' }), 
  async (req, res) => {
    // Aquí Passport ya autenticó exitosamente y agregó req.user
    const user = req.user;

    // Validar que req.user exista
    if (!user) {
      return res.redirect('myapp://login-failed');
    }

    // Generar el token (también puede usar el que ya viene en user.token si existe)
    const token = user.token || jwt.sign(
      {
        id: user.id,
        username: user.username,
        rol: user.rol
      },
      process.env.JWT_SECRET || 'fallback_secret',
      { expiresIn: '1h' }
    );

    // Redirigir a la app Flutter con el token y datos del usuario
    res.redirect(`myapp://login-success?token=${token}&username=${encodeURIComponent(user.username)}&id=${user.id}&rol=${user.rol}`);
  }
);

module.exports = router;
