const fs = require('fs');

exports.login = (req, res) => {
  const { username, password } = req.body;
  const users = JSON.parse(fs.readFileSync('./users.json', 'utf-8'));

  const userFound = users.find(
    (user) => user.username === username && user.password === password
  );

  if (userFound) {
    res.status(200).json({ message: `Bienvenido ${username}`, success: true });
  } else {
    res.status(401).json({ message: 'Usuario o contraseña incorrectos', success: false });
  }
};
