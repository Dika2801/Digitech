const CACHE_NAME = 'dika-ai-cache-v' + new Date().getTime();

// Saat aplikasi dibuka, paksa lewati masa tunggu cache lama
self.addEventListener('install', event => {
    self.skipWaiting();
});

// Bersihkan seluruh cache lama yang tersangkut di APK Android
self.addEventListener('activate', event => {
    event.waitUntil(
        caches.keys().then(cacheNames => {
            return Promise.all(
                cacheNames.map(cache => {
                    if (cache !== CACHE_NAME) {
                        console.log('Menghapus cache APK lama...');
                        return caches.delete(cache);
                    }
                })
            );
        }).then(() => self.clients.claim())
    );
});

// Strategi Network-First: Paksa ambil data dari GitHub dulu, kalau offline baru pakai cache
self.addEventListener('fetch', event => {
    event.respondWith(
        fetch(event.request).then(response => {
            return response;
        }).catch(() => {
            return caches.match(event.request);
        })
    );
});