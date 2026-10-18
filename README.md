# Cáritas Admin

App de iPad en SwiftUI. El backend Flask vive en otro repositorio.

## Configuración local

1. Copia `Config.example.xcconfig` a `Config.xcconfig` en la raíz del proyecto.
2. Cambia `API_BASE_URL` por la dirección del backend (sin `/` al final). El ejemplo usa el contenedor local expuesto en el puerto 3001.
3. Abre `caritas_admin.xcodeproj` en Xcode y usa un simulador de iPad compatible con el deployment target del proyecto (iOS 27 o superior).

`Config.xcconfig` es local y está ignorado por Git. No lo añadas al repositorio. Para probar con Docker, levanta el backend con `API_HOST_PORT=3001 docker compose up -d --build api` desde el repositorio Flask y accede con el usuario administrador de pruebas descrito allí.

La navegación incluye Resumen, Llamadas, Donantes, Casos y Usuarios. Las tres pantallas de administración leen `/admin/summary`, `/admin/calls` y `/admin/users`; no contienen datos de ejemplo en tiempo de ejecución.
