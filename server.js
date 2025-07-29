const express = require('express');
const { Pool } = require('pg');
const http = require('http');
const socketIo = require('socket.io');
const app = express();
const server = http.createServer(app);
const io = socketIo(server);

// Konfigurasi PostgreSQL
const pool = new Pool({
    user: 'newadmin',
    host: '192.168.18.230',
    database: 'db_nodejs',
    password: 'admin123',
    port: 5432,
});

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));
app.set('view engine', 'ejs');

// Halaman utama
app.get('/', async (req, res) => {
    const result = await pool.query('SELECT * FROM product ORDER BY id DESC');
    res.render('index', { product: result.rows });
});

// Tambah data
app.post('/add', async (req, res) => {
    const { name, code } = req.body;
    await pool.query('INSERT INTO product (name, code) VALUES ($1, $2)', [name, code]);
    io.emit('data_updated');
    res.redirect('/');
});

// Edit data
app.get('/edit/:id', async (req, res) => {
    const id = req.params.id;
    const result = await pool.query('SELECT * FROM product WHERE id = $1', [id]);
    if (result.rows.length === 0) return res.send('Data tidak ditemukan');
    res.render('edit', { product: result.rows[0] });
});

// Proses edit
app.post('/edit/:id', async (req, res) => {
    const id = req.params.id;
    const { name, code } = req.body;
    await pool.query('UPDATE product SET name = $1, code = $2 WHERE id = $3', [name, code, id]);
    io.emit('data_updated');
    res.redirect('/');
});

// Hapus data
app.post('/delete/:id', async (req, res) => {
    await pool.query('DELETE FROM product WHERE id = $1', [req.params.id]);
    io.emit('data_updated');
    res.redirect('/');
});



// Halaman stok
app.get('/stock', async (req, res) => {
    const result = await pool.query('SELECT * FROM stock ORDER BY id DESC');
    res.render('stock', { stock: result.rows });
});

// Tambah data
app.post('/add_stock', async (req, res) => {
    const { code_product, quantity } = req.body;
    await pool.query('INSERT INTO stock (code_product, quantity) VALUES ($1, $2)', [code_product, quantity]);
    io.emit('data_updated');
    res.redirect('/stock');
});

// Edit data
app.get('/edit_stock/:id', async (req, res) => {
    const id = req.params.id;
    const result = await pool.query('SELECT * FROM stock WHERE id = $1', [id]);
    if (result.rows.length === 0) return res.send('Data tidak ditemukan');
    res.render('stock_edit', { stock: result.rows[0] });
});

// Proses edit
app.post('/edit_stock/:id', async (req, res) => {
    const id = req.params.id;
    const { code_product, quantity } = req.body;
    await pool.query('UPDATE stock SET code_product = $1, quantity = $2 WHERE id = $3', [code_product, quantity, id]);
    io.emit('data_updated');
    res.redirect('/stock');
});

// Hapus data
app.post('/delete_stock/:id', async (req, res) => {
    await pool.query('DELETE FROM stock WHERE id = $1', [req.params.id]);
    io.emit('data_updated');
    res.redirect('/stock');
});



// Halaman purchase
app.get('/purchase', async (req, res) => {
    const result = await pool.query('SELECT * FROM purchase ORDER BY id DESC');
    res.render('purchase', { purchase: result.rows });
});

// Tambah data
app.post('/add_purchase', async (req, res) => {
    const { code_transaction, quantity } = req.body;
    await pool.query('INSERT INTO purchase (code_transaction, quantity) VALUES ($1, $2)', [code_transaction, quantity]);
    io.emit('data_updated');
    res.redirect('/purchase');
});

// Edit data
app.get('/edit_purchase/:id', async (req, res) => {
    const id = req.params.id;
    const result = await pool.query('SELECT * FROM purchase WHERE id = $1', [id]);
    if (result.rows.length === 0) return res.send('Data tidak ditemukan');
    res.render('purchase_edit', { purchase: result.rows[0] });
});

// Proses edit
app.post('/edit_purchase/:id', async (req, res) => {
    const id = req.params.id;
    const { code_transaction, quantity } = req.body;
    await pool.query('UPDATE purchase SET code_transaction = $1, quantity = $2 WHERE id = $3', [code_transaction, quantity, id]);
    io.emit('data_updated');
    res.redirect('/purchase');
});

// Hapus data
app.post('/delete_purchase/:id', async (req, res) => {
    await pool.query('DELETE FROM purchase WHERE id = $1', [req.params.id]);
    io.emit('data_updated');
    res.redirect('/purchase');
});









// Mulai server
const PORT = 3000;
server.listen(PORT, () => {
    console.log(`Server berjalan di http://localhost:${PORT}`);
});
