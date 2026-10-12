# Baraja Norteña — Sistema de peticiones 1.0

Este proyecto está preparado para conectarse a Supabase y funcionar entre varios celulares.

## Archivos
- `index.html`: catálogo público.
- `admin.html`: panel privado.
- `supabase.sql`: crea las tablas y políticas de seguridad.
- `config.js`: aquí se colocan la URL del proyecto y la clave anon de Supabase.

## Flujo
QR -> catálogo -> canción -> nombre/dedicatoria -> enviar -> panel privado -> COMPLACIDA.

No existe estado "Tocar" ni "Terminada".

## Importante
No uses una clave `service_role` en las páginas. Solo la clave pública `anon`.
Las letras deben ser introducidas por el administrador cuando tenga derecho o permiso para almacenarlas.
