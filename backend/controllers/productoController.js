//backend/controllers/productoController.js
const mysql = require('mysql2');

// Crear conexión
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '0096',
  database: 'flutter1'
});

// Promisificar la conexión
const db = connection.promise();

// GET /api/productos
const getProductos = async (req, res) => {
  try {
    const [results] = await db.query('SELECT * FROM productos');
    res.json(results);
  } catch (err) {
    console.error('Error al obtener productos:', err);
    res.status(500).json({ error: 'Error al obtener productos' });
  }
};

// GET /api/productos/:id
const getProductoById = async (req, res) => {
  try {
    const { id } = req.params;
    const [results] = await db.query('SELECT * FROM productos WHERE id = ?', [id]);
    
    if (results.length === 0) {
      return res.status(404).json({ message: 'Producto no encontrado' });
    }
    
    res.json(results[0]);
  } catch (err) {
    console.error('Error al obtener producto:', err);
    res.status(500).json({ error: 'Error al obtener producto' });
  }
};

// POST /api/productos
const createProducto = async (req, res) => {
  try {
    const { nombre, precio, descripcion, stock } = req.body;
    const [result] = await db.query(
      'INSERT INTO productos (nombre, precio, descripcion, stock) VALUES (?, ?, ?, ?)',
      [nombre, precio, descripcion || '', stock || 0]
    );
    
    res.status(201).json({ 
      message: 'Producto creado', 
      id: result.insertId,
      nombre,
      precio,
      descripcion,
      stock: stock || 0
    });
  } catch (err) {
    console.error('Error al crear producto:', err);
    res.status(500).json({ error: 'Error al crear producto' });
  }
};

// PUT /api/productos/:id
const updateProducto = async (req, res) => {
  try {
    const { id } = req.params;
    const { nombre, precio, descripcion, stock } = req.body;
    
    const [result] = await db.query(
      'UPDATE productos SET nombre = ?, precio = ?, descripcion = ?, stock = ? WHERE id = ?',
      [nombre, precio, descripcion, stock, id]
    );
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Producto no encontrado' });
    }
    
    res.json({ message: 'Producto actualizado' });
  } catch (err) {
    console.error('Error al actualizar producto:', err);
    res.status(500).json({ error: 'Error al actualizar producto' });
  }
};

// DELETE /api/productos/:id
const deleteProducto = async (req, res) => {
  try {
    const { id } = req.params;
    const [result] = await db.query('DELETE FROM productos WHERE id = ?', [id]);
    
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Producto no encontrado' });
    }
    
    res.json({ message: 'Producto eliminado' });
  } catch (err) {
    console.error('Error al eliminar producto:', err);
    res.status(500).json({ error: 'Error al eliminar producto' });
  }
};

// POST /api/productos/:id/vender
const venderProducto = async (req, res) => {
  try {
    const { id } = req.params;
    const { cantidad } = req.body;

    // Validar cantidad
    if (!cantidad || cantidad <= 0) {
      return res.status(400).json({ error: 'Cantidad inválida' });
    }

    // Iniciar transacción
    await db.beginTransaction();

    // 1. Verificar que el producto existe y obtener datos
    const [productos] = await db.query("SELECT * FROM productos WHERE id = ?", [id]);
    if (productos.length === 0) {
      await db.rollback();
      return res.status(404).json({ error: "Producto no encontrado" });
    }

    const producto = productos[0];

    // 2. Verificar que hay suficiente stock
    if (producto.stock < cantidad) {
      await db.rollback();
      return res.status(400).json({ 
        error: "Stock insuficiente",
        stockDisponible: producto.stock,
        cantidadSolicitada: cantidad
      });
    }

    // 3. Actualizar stock usando operación atómica
    await db.query("UPDATE productos SET stock = stock - ? WHERE id = ?", [cantidad, id]);

    // 4. Registrar venta en tabla ventas
    const total = parseFloat(producto.precio) * parseInt(cantidad);
    const [ventaResult] = await db.query(
      'INSERT INTO ventas (producto_id, cantidad, precio_unitario, total, fecha) VALUES (?, ?, ?, ?, NOW())',
      [id, cantidad, producto.precio, total]
    );

    // 5. Confirmar transacción
    await db.commit();

    // Calcular nuevo stock
    const nuevoStock = producto.stock - cantidad;

    // Respuesta exitosa
    res.json({
      success: true,
      message: "Venta realizada con éxito",
      venta: {
        id: ventaResult.insertId,
        producto_id: parseInt(id),
        producto_nombre: producto.nombre,
        cantidad: parseInt(cantidad),
        precio_unitario: parseFloat(producto.precio),
        total: total
      },
      producto: {
        id: parseInt(id),
        nombre: producto.nombre,
        stockAnterior: producto.stock,
        stockActual: nuevoStock
      }
    });

  } catch (error) {
    // Rollback en caso de error
    try {
      await db.rollback();
    } catch (rollbackError) {
      console.error("Error en rollback:", rollbackError);
    }
    
    console.error("Error en venderProducto:", error);
    return res.status(500).json({ error: "Error al realizar la venta" });
  }
};

// POST /api/productos/:id/reabastecer
const reabastecerProducto = async (req, res) => {
  try {
    const { id } = req.params;
    const { cantidad } = req.body;

    // Validar cantidad
    if (!cantidad || cantidad <= 0) {
      return res.status(400).json({ error: "Cantidad inválida" });
    }

    // Iniciar transacción
    await db.beginTransaction();

    // 1. Verificar que el producto existe
    const [producto] = await db.query("SELECT * FROM productos WHERE id = ?", [id]);
    if (producto.length === 0) {
      await db.rollback();
      return res.status(404).json({ error: "Producto no encontrado" });
    }

    const stockAnterior = producto[0].stock;
    const nuevoStock = stockAnterior + parseInt(cantidad);

    // 2. Actualizar stock
    await db.query("UPDATE productos SET stock = ? WHERE id = ?", [nuevoStock, id]);

    // 3. Guardar historial de reabastecimiento
    const [reabastecimientoResult] = await db.query(
      "INSERT INTO reabastecimientos (producto_id, cantidad, fecha) VALUES (?, ?, NOW())",
      [id, cantidad]
    );

    // 4. Confirmar transacción
    await db.commit();

    res.json({ 
      success: true,
      message: "Reabastecimiento exitoso", 
      reabastecimiento: {
        id: reabastecimientoResult.insertId,
        producto_id: parseInt(id),
        producto_nombre: producto[0].nombre,
        cantidad: parseInt(cantidad)
      },
      producto: {
        id: parseInt(id),
        nombre: producto[0].nombre,
        stockAnterior: stockAnterior,
        stockActual: nuevoStock
      }
    });

  } catch (err) {
    // Rollback en caso de error
    try {
      await db.rollback();
    } catch (rollbackError) {
      console.error("Error en rollback:", rollbackError);
    }
    
    console.error("Error en reabastecerProducto:", err);
    res.status(500).json({ error: "Error al reabastecer producto" });
  }
};

// GET /api/productos/ventas/historial
const historialVentas = async (req, res) => {
  try {
    const [ventas] = await db.query(
      `SELECT v.id, p.nombre AS producto, v.cantidad, v.precio_unitario, v.total, v.fecha
       FROM ventas v
       JOIN productos p ON v.producto_id = p.id
       ORDER BY v.fecha DESC`
    );
    res.json(ventas);
  } catch (err) {
    console.error("Error en historialVentas:", err);
    res.status(500).json({ error: "Error al obtener historial de ventas" });
  }
};

// GET /api/productos/reabastecimientos/historial
const historialReabastecimientos = async (req, res) => {
  try {
    const [reabastecimientos] = await db.query(
      `SELECT r.id, p.nombre AS producto, r.cantidad, r.fecha
       FROM reabastecimientos r
       JOIN productos p ON r.producto_id = p.id
       ORDER BY r.fecha DESC`
    );
    res.json(reabastecimientos);
  } catch (err) {
    console.error("Error en historialReabastecimientos:", err);
    res.status(500).json({ error: "Error al obtener historial de reabastecimientos" });
  }
};

// GET /api/productos/:id/movimientos
const movimientosProducto = async (req, res) => {
  try {
    const { id } = req.params;

    // Verificar que el producto existe
    const [producto] = await db.query("SELECT * FROM productos WHERE id = ?", [id]);
    if (producto.length === 0) {
      return res.status(404).json({ error: "Producto no encontrado" });
    }

    // Obtener ventas del producto
    const [ventas] = await db.query(
      `SELECT 'venta' as tipo, cantidad, total as monto, fecha
       FROM ventas 
       WHERE producto_id = ?
       ORDER BY fecha DESC`,
      [id]
    );

    // Obtener reabastecimientos del producto
    const [reabastecimientos] = await db.query(
      `SELECT 'reabastecimiento' as tipo, cantidad, NULL as monto, fecha
       FROM reabastecimientos 
       WHERE producto_id = ?
       ORDER BY fecha DESC`,
      [id]
    );

    // Combinar y ordenar todos los movimientos
    const movimientos = [...ventas, ...reabastecimientos]
      .sort((a, b) => new Date(b.fecha) - new Date(a.fecha));

    res.json({
      producto: producto[0],
      movimientos: movimientos
    });

  } catch (err) {
    console.error("Error en movimientosProducto:", err);
    res.status(500).json({ error: "Error al obtener movimientos del producto" });
  }
};

module.exports = {
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
};
