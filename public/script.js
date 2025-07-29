const socket = io();

socket.on('data_updated', () => {
    // Refresh otomatis jika data berubah
    window.location.reload();
});
