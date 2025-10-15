// Configuración de Google OAuth
// IMPORTANTE: Reemplaza 'YOUR_GOOGLE_CLIENT_ID' con tu Client ID real de Google Cloud Console

export const GOOGLE_CONFIG = {
  // Obtén tu Client ID desde: https://console.cloud.google.com/
  // 1. Ve a "APIs & Services" > "Credentials"
  // 2. Crea un "OAuth 2.0 Client ID" para aplicación web
  // 3. Agrega tu dominio (localhost:4201 para desarrollo)
  // 4. Copia el Client ID aquí
  CLIENT_ID: '811217922557-7jss9har7tsaikc9r6hlefdtuf6bg3ci.apps.googleusercontent.com',
  
  // URLs autorizadas (deben coincidir con las configuradas en Google Cloud Console)
  AUTHORIZED_ORIGINS: [
    'http://localhost:4201',
    'http://localhost:4200',
    'https://yourdomain.com' // Reemplaza con tu dominio de producción
  ],
  
  // URLs de redirección autorizadas
  AUTHORIZED_REDIRECT_URIS: [
    'http://localhost:4201',
    'http://localhost:4200',
    'https://yourdomain.com' // Reemplaza con tu dominio de producción
  ]
};

// Instrucciones para configurar Google OAuth:
/*
1. Ve a Google Cloud Console: https://console.cloud.google.com/
2. Crea un nuevo proyecto o selecciona uno existente
3. Habilita la Google+ API o Google Identity API
4. Ve a "APIs & Services" > "Credentials"
5. Haz clic en "Create Credentials" > "OAuth 2.0 Client ID"
6. Selecciona "Web application"
7. En "Authorized JavaScript origins", agrega:
   - http://localhost:4201
   - http://localhost:4200
   - https://yourdomain.com (tu dominio de producción)
8. En "Authorized redirect URIs", agrega las mismas URLs
9. Copia el "Client ID" y reemplaza 'YOUR_GOOGLE_CLIENT_ID' en este archivo
10. En tu backend Rails, configura las mismas credenciales
*/
