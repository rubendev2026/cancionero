# Baraja Norteña — Sistema de peticiones 2.0

Sitio 100% estático (HTML + CSS + JS, sin compilar): se publica tal cual en **GitHub Pages**
y se conecta a Supabase desde el navegador.

## Archivos
- `index.html`: catálogo público (búsqueda, filtros rápidos por género, 🔥 más pedidas, barra A–Z, petición en ventana emergente).
- `admin.html`: panel privado con 3 pestañas: **Peticiones**, **Estadísticas** y **Repertorio**.
- `styles.css`: estilos compartidos.
- `supabase.sql`: tablas, políticas de seguridad y función `register_request`.
- `config.js`: URL del proyecto y clave pública `anon` de Supabase.

## Publicar en GitHub Pages
Sube todos los archivos a la raíz del repositorio > Settings > Pages > Deploy from a branch > `main` / root.
No requiere cambios en la base de datos: la versión 2.0 usa las mismas tablas y funciones.

## Estadísticas (admin)
Filtros: Todo / Hoy / 7 días / 30 días. Incluye peticiones totales, canciones distintas, pendientes,
tiempo promedio de atención, ranking por canción (veces pedida, complacidas, pendientes, última vez;
toca una canción para ver quién la pidió y con qué dedicatoria), peticiones por género, por hora,
últimos 7 días y canciones que nunca se han pedido.

## Importante
No uses una clave `service_role` en las páginas. Solo la clave pública `anon`.
Las letras deben ser introducidas por el administrador cuando tenga derecho o permiso para almacenarlas.
