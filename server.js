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

// Hapus data
app.post('/delete/:id', async (req, res) => {
    await pool.query('DELETE FROM product WHERE id = $1', [req.params.id]);
    io.emit('data_updated');
    res.redirect('/');
});

// Mulai server
const PORT = 3000;
server.listen(PORT, () => {
    console.log(`Server berjalan di http://localhost:${PORT}`);
});
