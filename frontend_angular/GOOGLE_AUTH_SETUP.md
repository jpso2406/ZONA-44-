# Configuración de Autenticación con Google

## Pasos para configurar Google OAuth

### 1. Configurar Google Cloud Console

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Crea un nuevo proyecto o selecciona uno existente
3. Habilita la **Google Identity API**:
   - Ve a "APIs & Services" > "Library"
   - Busca "Google Identity"
   - Habilita la API

### 2. Crear Credenciales OAuth 2.0

1. Ve a "APIs & Services" > "Credentials"
2. Haz clic en "Create Credentials" > "OAuth 2.0 Client ID"
3. Selecciona "Web application"
4. Configura las URLs autorizadas:

   **Authorized JavaScript origins:**
   ```
   http://localhost:4201
   http://localhost:4200
   https://yourdomain.com
   ```

   **Authorized redirect URIs:**
   ```
   http://localhost:4201
   http://localhost:4200
   https://yourdomain.com
   ```

5. Copia el **Client ID** generado

### 3. Configurar el Frontend Angular

1. Abre el archivo `src/app/config/google.config.ts`
2. Reemplaza `'YOUR_GOOGLE_CLIENT_ID'` con tu Client ID real:
   ```typescript
   CLIENT_ID: 'tu-client-id-real-aqui.apps.googleusercontent.com',
   ```

### 4. Configurar el Backend Rails

En tu controlador Rails, asegúrate de tener el endpoint `/api/v1/auth/google`:

```ruby
# app/controllers/api/v1/auth_controller.rb
module Api
  module V1
    class AuthController < ApplicationController
      skip_before_action :verify_authenticity_token
      skip_before_action :authenticate_user!

      # POST /api/v1/auth/google
      def google
        id_token = params[:id_token]
        
        # Verificar el token con Google
        # Implementar la verificación del id_token aquí
        
        # Crear o encontrar el usuario
        # Generar api_token
        # Devolver respuesta
        
        render json: { 
          success: true, 
          user_id: user.id, 
          token: api_token 
        }
      end
    end
  end
end
```

### 5. Probar la Integración

1. Inicia el servidor Angular: `ng serve --port 4201`
2. Ve a la página de login
3. Haz clic en el botón "Sign in with Google"
4. Completa el flujo de autenticación
5. Verifica que el usuario se autentique correctamente

## Estructura de Archivos

```
src/
├── app/
│   ├── config/
│   │   └── google.config.ts          # Configuración de Google
│   ├── Services/
│   │   └── google-auth.service.ts    # Servicio de autenticación Google
│   └── Pages/
│       └── auth/
│           ├── login/
│           │   ├── login.ts          # Componente de login actualizado
│           │   ├── login.html        # Template con botón Google
│           │   └── login.css         # Estilos del botón Google
│           └── auth.service.ts       # AuthService con método Google
└── index.html                        # Script de Google Identity Services
```

## Notas Importantes

- **Desarrollo**: Usa `localhost:4201` en las URLs autorizadas
- **Producción**: Reemplaza con tu dominio real
- **Seguridad**: Nunca expongas el Client Secret en el frontend
- **Testing**: Usa cuentas de prueba para desarrollo

## Solución de Problemas

### Error: "Invalid client"
- Verifica que el Client ID sea correcto
- Asegúrate de que las URLs autorizadas coincidan exactamente

### Error: "Origin mismatch"
- Verifica que `localhost:4201` esté en las URLs autorizadas
- Asegúrate de usar el puerto correcto

### El botón no aparece
- Verifica que el script de Google se cargue correctamente
- Revisa la consola del navegador para errores
- Asegúrate de que el elemento `#google-signin-button` exista en el DOM
