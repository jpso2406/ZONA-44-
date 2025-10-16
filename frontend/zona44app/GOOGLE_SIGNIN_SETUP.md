# Configuración de Google Sign-In para Zona44 App

## Pasos completados ✅

1. **Dependencias agregadas**: Se agregó `google_sign_in: ^6.2.1` al `pubspec.yaml`
2. **Servicio creado**: Se extendió `UserService` con métodos para autenticación con Google
3. **BLoC actualizado**: Se agregó soporte para `GoogleLoginSubmitted` en `LoginBloc`
4. **UI integrada**: Se agregó botón "Continuar con Google" en la pantalla de login

## Pasos pendientes para completar la configuración

### Para Android:

1. **Crear proyecto en Google Cloud Console**:
   - Ve a [Google Cloud Console](https://console.cloud.google.com/)
   - Crea un nuevo proyecto o selecciona uno existente
   - Habilita la API de Google Sign-In

2. **Configurar OAuth 2.0**:
   - Ve a "Credenciales" en el menú lateral
   - Crea credenciales OAuth 2.0 para Android
   - Agrega tu SHA-1 fingerprint:
     ```bash
     keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
     ```

3. **Descargar google-services.json**:
   - Descarga el archivo `google-services.json` desde Google Cloud Console
   - Colócalo en `android/app/google-services.json`

4. **Actualizar build.gradle**:
   - En `android/build.gradle`, agrega:
     ```gradle
     buildscript {
         dependencies {
             classpath 'com.google.gms:google-services:4.3.15'
         }
     }
     ```
   - En `android/app/build.gradle`, agrega:
     ```gradle
     apply plugin: 'com.google.gms.google-services'
     ```

### Para iOS:

1. **Configurar OAuth 2.0 para iOS**:
   - En Google Cloud Console, crea credenciales OAuth 2.0 para iOS
   - Usa tu Bundle ID de iOS

2. **Descargar GoogleService-Info.plist**:
   - Descarga el archivo `GoogleService-Info.plist`
   - Colócalo en `ios/Runner/GoogleService-Info.plist`

3. **Actualizar Info.plist**:
   - En `ios/Runner/Info.plist`, agrega:
     ```xml
     <key>CFBundleURLTypes</key>
     <array>
         <dict>
             <key>CFBundleURLName</key>
             <string>REVERSED_CLIENT_ID</string>
             <key>CFBundleURLSchemes</key>
             <array>
                 <string>REVERSED_CLIENT_ID_FROM_GOOGLE_SERVICE_INFO</string>
             </array>
         </dict>
     </array>
     ```

## Variables de entorno requeridas

En tu backend Rails, asegúrate de tener configurado:

```ruby
# En tu .env o variables de entorno
GOOGLE_CLIENT_ID=tu_google_client_id_aqui
```

## Cómo funciona la integración

1. **Usuario toca "Continuar con Google"**
2. **Se abre el flujo de Google Sign-In**
3. **Usuario selecciona cuenta y autoriza**
4. **Se obtiene el ID token de Google**
5. **Se envía el token al endpoint `/api/v1/auth/google`**
6. **Backend valida el token y crea/autentica usuario**
7. **Se retorna el token de la aplicación**
8. **Usuario es redirigido al Home**

## Endpoint del backend

El backend ya tiene configurado el endpoint:

```ruby
# POST /api/v1/auth/google
def google
  id_token = params[:id_token]
  validator = GoogleIDToken::Validator.new
  begin
    payload = validator.check(id_token, ENV["GOOGLE_CLIENT_ID"])
    user = User.find_or_create_by(email: payload["email"]) do |u|
      u.first_name = payload["given_name"]
      u.last_name = payload["family_name"]
      u.password = SecureRandom.hex(16)
    end
    user.update(api_token: SecureRandom.hex(32)) unless user.api_token.present?
    render json: { success: true, user: user.as_json(only: [:id, :email, :first_name, :last_name]), api_token: user.api_token }
  rescue => e
    render json: { success: false, error: e.message }, status: :unauthorized
  end
end
```

## Próximos pasos

1. Configurar Google Cloud Console
2. Descargar archivos de configuración
3. Actualizar archivos de configuración de Android/iOS
4. Probar la funcionalidad

## Notas importantes

- Asegúrate de usar el mismo `GOOGLE_CLIENT_ID` en el backend y en la configuración de Flutter
- Los archivos de configuración (`google-services.json` y `GoogleService-Info.plist`) contienen información sensible, no los subas a control de versiones
- Prueba la funcionalidad en dispositivos reales, no solo en emuladores
