const express = require('express');
const { Pool } = require('pg');
const http = require('http');
const socketIo = require('socket.io');
const app = express();
const server = http.createServer(app);
const io = socketIo(server);
const { askChatGPT } = require('./ai');
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

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

    



app.post('/add', async (req, res) => {
    const { name, code, type, brand, unit, sku } = req.body;
    await pool.query('INSERT INTO product (name, code, type, brand, unit, sku) VALUES ($1, $2, $3, $4, $5, $6)', [name, code, type, brand, unit, sku]);
    io.emit('data_updated');
    res.redirect('/');
});


app.get('/edit/:id', async (req, res) => {
    const id = req.params.id;
    const result = await pool.query('SELECT * FROM product WHERE id = $1', [id]);
    if (result.rows.length === 0) return res.send('Data tidak ditemukan');
    res.render('edit', { product: result.rows[0] });
});


app.post('/edit/:id', async (req, res) => {
    const id = req.params.id;
    const { name, code, type, brand, unit, sku } = req.body;
    await pool.query('UPDATE product SET name = $1, code = $2, type = $4, brand = $5, unit = $6, sku = $7 WHERE id = $3', [name, code, id, type, brand, unit, sku ]);
    io.emit('data_updated');
    res.redirect('/');
});


app.post('/delete/:id', async (req, res) => {
    await pool.query('DELETE FROM product WHERE id = $1', [req.params.id]);
    io.emit('data_updated');
    res.redirect('/');
});



// Halaman stok
app.get('/stock', async (req, res) => {
    const stockResult = await pool.query(`
    SELECT 
        stock.id,
        stock.code_product,
        stock.quantity,
        stock.create_at,
        product.name AS product_name,
        product.brand,
        product.unit,
        product.sku
    FROM stock
    JOIN product ON stock.code_product = product.code
    ORDER BY stock.id DESC
`);
    const productResult = await pool.query('SELECT * FROM product ORDER BY name ASC');
    res.render('stock', {
        stock: stockResult.rows,
        products: productResult.rows
    });
});


app.post('/add_stock', async (req, res) => {
    const { code_product, quantity } = req.body;
    await pool.query('INSERT INTO stock (code_product, quantity) VALUES ($1, $2)', [code_product, quantity]);
    io.emit('data_updated');
    res.redirect('/stock');
});


app.get('/edit_stock/:id', async (req, res) => {
    const id = req.params.id;

    const result = await pool.query(`
        SELECT 
            stock.*,
            product.name AS product_name
        FROM stock
        JOIN product ON stock.code_product = product.code
        WHERE stock.id = $1
    `, [id]);

    if (result.rows.length === 0) return res.send('Data tidak ditemukan');

    res.render('stock_edit', { stock: result.rows[0] });
});


app.post('/edit_stock/:id', async (req, res) => {
    const id = req.params.id;
    const { code_product, quantity } = req.body;
    await pool.query('UPDATE stock SET code_product = $1, quantity = $2 WHERE id = $3', [code_product, quantity, id]);
    io.emit('data_updated');
    res.redirect('/stock');
});


app.post('/delete_stock/:id', async (req, res) => {
    await pool.query('DELETE FROM stock WHERE id = $1', [req.params.id]);
    io.emit('data_updated');
    res.redirect('/stock');
});



// Halaman purchase
app.get('/purchase', async (req, res) => {
    const result = await pool.query(`
        SELECT 
            purchase.id,
            purchase.code_transaction,
            purchase.quantity,
            purchase.create_at,
            product.code,
            product.name,
            product.type,
            product.brand,
            product.unit,
            product.sku
        FROM purchase
        JOIN product ON purchase.code_transaction = product.code
        ORDER BY purchase.id DESC
    `);
    const productResult = await pool.query('SELECT * FROM product ORDER BY name ASC');

    res.render('purchase', { 
        purchase: result.rows,
        products: productResult.rows
    });
});

app.post('/add_purchase', async (req, res) => {
    const { code_transaction, quantity } = req.body;

    const client = await pool.connect();
    try {
        await client.query('BEGIN');

        await client.query(
            'INSERT INTO purchase (code_transaction, quantity) VALUES ($1, $2)',
            [code_transaction, quantity]
        );

        await client.query(
            'UPDATE stock SET quantity = quantity - $1 WHERE code_product = $2',
            [quantity, code_transaction]
        );

        await client.query('COMMIT');
        io.emit('data_updated');
        res.redirect('/purchase');
    } catch (err) {
        await client.query('ROLLBACK');
        console.error('Gagal tambah purchase atau update stok:', err);
        res.status(500).send('Terjadi kesalahan saat menyimpan data');
    } finally {
        client.release();
    }
});


app.get('/edit_purchase/:id', async (req, res) => {
    const id = req.params.id;
    const result = await pool.query('SELECT * FROM purchase WHERE id = $1', [id]);
    if (result.rows.length === 0) return res.send('Data tidak ditemukan');
    res.render('purchase_edit', { purchase: result.rows[0] });
});


app.post('/edit_purchase/:id', async (req, res) => {
    const id = req.params.id;
    const { code_transaction, quantity } = req.body;
    await pool.query('UPDATE purchase SET code_transaction = $1, quantity = $2 WHERE id = $3', [code_transaction, quantity, id]);
    io.emit('data_updated');
    res.redirect('/purchase');
});


app.post('/delete_purchase/:id', async (req, res) => {
    await pool.query('DELETE FROM purchase WHERE id = $1', [req.params.id]);
    io.emit('data_updated');
    res.redirect('/purchase');
});




app.post('/ask-ai', async (req, res) => {
    const { question } = req.body;

    try {
        const answer = await askChatGPT(question);
        res.json({ answer });
    } catch (error) {
        console.error(error);
        res.status(500).send('Gagal terhubung ke AI');
    }
});




// Mulai server
const PORT = 3000;
server.listen(PORT, () => {
    console.log(`Server berjalan di http://localhost:${PORT}`);
});
