import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// El título de la aplicación
  ///
  /// In es, this message translates to:
  /// **'Zona 44'**
  String get appTitle;

  /// Botón para abrir Google Maps
  ///
  /// In es, this message translates to:
  /// **'Cómo llegar'**
  String get howToGetThere;

  /// Botón de ayuda
  ///
  /// In es, this message translates to:
  /// **'Ayuda'**
  String get help;

  /// Botón del menú
  ///
  /// In es, this message translates to:
  /// **'MENÚ'**
  String get menu;

  /// Botón de reserva
  ///
  /// In es, this message translates to:
  /// **'RESERVAR'**
  String get reserve;

  /// Selector de idioma
  ///
  /// In es, this message translates to:
  /// **'Idioma'**
  String get language;

  /// Idioma español
  ///
  /// In es, this message translates to:
  /// **'Español'**
  String get spanish;

  /// Idioma inglés
  ///
  /// In es, this message translates to:
  /// **'English'**
  String get english;

  /// Título del diálogo de ayuda
  ///
  /// In es, this message translates to:
  /// **'Centro de ayuda'**
  String get helpCenter;

  /// Mensaje de ayuda con información de contacto
  ///
  /// In es, this message translates to:
  /// **'Si necesitas asistencia con tus pedidos o reservas, comunícate con nosotros vía WhatsApp o correo electrónico.\n\n📞 Tel: +57 301 649 7860\n✉️ Email: contacto@zona44.com'**
  String get helpMessage;

  /// Botón para cerrar diálogos
  ///
  /// In es, this message translates to:
  /// **'Cerrar'**
  String get close;

  /// Título de la página de login
  ///
  /// In es, this message translates to:
  /// **'Iniciar Sesión'**
  String get login;

  /// Campo de email
  ///
  /// In es, this message translates to:
  /// **'Correo electrónico'**
  String get email;

  /// Campo de contraseña
  ///
  /// In es, this message translates to:
  /// **'Contraseña'**
  String get password;

  /// Botón de ingresar
  ///
  /// In es, this message translates to:
  /// **'Ingresar'**
  String get enter;

  /// Enlace para recuperar contraseña
  ///
  /// In es, this message translates to:
  /// **'¿Olvidaste tu contraseña?'**
  String get forgotPassword;

  /// Texto para continuar con Google
  ///
  /// In es, this message translates to:
  /// **'Continuar con'**
  String get continueWith;

  /// Botón de Google Sign-In
  ///
  /// In es, this message translates to:
  /// **'Continuar con Google'**
  String get continueWithGoogle;

  /// Enlace para registrarse
  ///
  /// In es, this message translates to:
  /// **'¿No tienes cuenta? Regístrate aquí'**
  String get noAccount;

  /// Mensaje de campo requerido
  ///
  /// In es, this message translates to:
  /// **'Campo requerido'**
  String get requiredField;

  /// Mensaje de credenciales inválidas
  ///
  /// In es, this message translates to:
  /// **'Credenciales inválidas'**
  String get invalidCredentials;

  /// Pestaña de perfil
  ///
  /// In es, this message translates to:
  /// **'Perfil'**
  String get profile;

  /// Pestaña de carrito
  ///
  /// In es, this message translates to:
  /// **'Carrito'**
  String get cart;

  /// Pestaña de inicio
  ///
  /// In es, this message translates to:
  /// **'Inicio'**
  String get home;

  /// Mensaje cuando el carrito está vacío
  ///
  /// In es, this message translates to:
  /// **'¡Tu carrito está vacío!'**
  String get cartEmpty;

  /// Subtítulo cuando el carrito está vacío
  ///
  /// In es, this message translates to:
  /// **'Agrega productos y disfruta de la mejor experiencia'**
  String get cartEmptySubtitle;

  /// Botón para eliminar producto del carrito
  ///
  /// In es, this message translates to:
  /// **'Eliminar'**
  String get remove;

  /// Etiqueta del total a pagar
  ///
  /// In es, this message translates to:
  /// **'Total a pagar:'**
  String get totalToPay;

  /// Botón para vaciar el carrito
  ///
  /// In es, this message translates to:
  /// **'Vaciar carrito'**
  String get clearCart;

  /// Botón para proceder al pago
  ///
  /// In es, this message translates to:
  /// **'Ir a pagar'**
  String get goToPay;

  /// Título del formulario de datos del cliente
  ///
  /// In es, this message translates to:
  /// **'Datos del cliente'**
  String get customerData;

  /// Etiqueta del tipo de entrega
  ///
  /// In es, this message translates to:
  /// **'Tipo de entrega'**
  String get deliveryType;

  /// Opción de entrega a domicilio
  ///
  /// In es, this message translates to:
  /// **'Domicilio'**
  String get delivery;

  /// Opción de recoger en el local
  ///
  /// In es, this message translates to:
  /// **'Recoger en el local'**
  String get pickup;

  /// Campo de nombre
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get name;

  /// Campo de teléfono
  ///
  /// In es, this message translates to:
  /// **'Teléfono'**
  String get phone;

  /// Botón para continuar
  ///
  /// In es, this message translates to:
  /// **'Continuar'**
  String get continueButton;

  /// Título del formulario de pago con tarjeta
  ///
  /// In es, this message translates to:
  /// **'Pago con tarjeta (Sandbox)'**
  String get cardPayment;

  /// Título de las categorías del menú
  ///
  /// In es, this message translates to:
  /// **'Categorías'**
  String get categories;

  /// Botón para agregar producto al carrito
  ///
  /// In es, this message translates to:
  /// **'Agregar al carrito'**
  String get addToCart;

  /// Etiqueta de precio
  ///
  /// In es, this message translates to:
  /// **'Precio'**
  String get price;

  /// Etiqueta de descripción
  ///
  /// In es, this message translates to:
  /// **'Descripción'**
  String get description;

  /// Mensaje de error al cargar el menú
  ///
  /// In es, this message translates to:
  /// **'Error al cargar el menú'**
  String get menuError;

  /// Botón para reintentar
  ///
  /// In es, this message translates to:
  /// **'Reintentar'**
  String get retry;

  /// Mensaje de carga
  ///
  /// In es, this message translates to:
  /// **'Cargando...'**
  String get loading;

  /// Botón para volver atrás
  ///
  /// In es, this message translates to:
  /// **'Atrás'**
  String get back;

  /// Título de la sección de perfil
  ///
  /// In es, this message translates to:
  /// **'Mi Perfil'**
  String get myProfile;

  /// Título de la sección de órdenes
  ///
  /// In es, this message translates to:
  /// **'Mis Órdenes'**
  String get myOrders;

  /// Título de la sección de órdenes de administrador
  ///
  /// In es, this message translates to:
  /// **'Pedidos (Admin)'**
  String get adminOrders;

  /// Botón para cerrar sesión
  ///
  /// In es, this message translates to:
  /// **'Cerrar sesión'**
  String get logout;

  /// Tooltip para datos de perfil
  ///
  /// In es, this message translates to:
  /// **'Datos de perfil'**
  String get profileData;

  /// Tooltip para historial de órdenes
  ///
  /// In es, this message translates to:
  /// **'Historial de órdenes'**
  String get orderHistory;

  /// Tooltip para órdenes de administrador
  ///
  /// In es, this message translates to:
  /// **'Pedidos de todos los usuarios'**
  String get allUserOrders;

  /// Campo de nombre
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get firstName;

  /// Campo de apellido
  ///
  /// In es, this message translates to:
  /// **'Apellido'**
  String get lastName;

  /// Campo de dirección
  ///
  /// In es, this message translates to:
  /// **'Dirección'**
  String get address;

  /// Campo de ciudad
  ///
  /// In es, this message translates to:
  /// **'Ciudad'**
  String get city;

  /// Campo de departamento
  ///
  /// In es, this message translates to:
  /// **'Departamento'**
  String get department;

  /// Botón para editar perfil
  ///
  /// In es, this message translates to:
  /// **'Editar Perfil'**
  String get editProfile;

  /// Botón para eliminar cuenta
  ///
  /// In es, this message translates to:
  /// **'Eliminar Cuenta'**
  String get deleteAccount;

  /// Mensaje para iniciar sesión
  ///
  /// In es, this message translates to:
  /// **'Debes iniciar sesión para ver tu perfil'**
  String get mustLoginToViewProfile;

  /// Botón para iniciar sesión
  ///
  /// In es, this message translates to:
  /// **'Iniciar sesión'**
  String get signIn;

  /// Mensaje de carga del perfil
  ///
  /// In es, this message translates to:
  /// **'Cargando perfil...'**
  String get loadingProfile;

  /// Mensaje de error al cargar perfil
  ///
  /// In es, this message translates to:
  /// **'Error al cargar el perfil'**
  String get profileError;

  /// Título del diálogo de editar perfil
  ///
  /// In es, this message translates to:
  /// **'Editar Perfil'**
  String get editProfileTitle;

  /// Botón para guardar
  ///
  /// In es, this message translates to:
  /// **'Guardar'**
  String get save;

  /// Botón para cancelar
  ///
  /// In es, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// Título del diálogo de eliminar cuenta
  ///
  /// In es, this message translates to:
  /// **'Eliminar Cuenta'**
  String get deleteAccountTitle;

  /// Advertencia de eliminación de cuenta
  ///
  /// In es, this message translates to:
  /// **'Esta acción es irreversible. Todos tus datos serán eliminados permanentemente.'**
  String get deleteAccountWarning;

  /// Instrucción para confirmar eliminación
  ///
  /// In es, this message translates to:
  /// **'Escribe \'ELIMINAR\' para confirmar:'**
  String get typeDeleteToConfirm;

  /// Botón para confirmar eliminación
  ///
  /// In es, this message translates to:
  /// **'Confirmar Eliminación'**
  String get confirmDelete;

  /// Título de la página de registro
  ///
  /// In es, this message translates to:
  /// **'Crea tu cuenta'**
  String get createAccount;

  /// Subtítulo de la página de registro
  ///
  /// In es, this message translates to:
  /// **'Completa la información para continuar'**
  String get completeInfoToContinue;

  /// Botón de registro
  ///
  /// In es, this message translates to:
  /// **'Registrarse'**
  String get register;

  /// Mensaje de registro exitoso
  ///
  /// In es, this message translates to:
  /// **'Registro exitoso'**
  String get registerSuccess;

  /// Mensaje de validación de email
  ///
  /// In es, this message translates to:
  /// **'Ingrese un correo válido'**
  String get enterValidEmail;

  /// Mensaje de validación de contraseña
  ///
  /// In es, this message translates to:
  /// **'Mínimo 6 caracteres'**
  String get minimum6Characters;

  /// Mensaje de validación de teléfono
  ///
  /// In es, this message translates to:
  /// **'Solo números'**
  String get onlyNumbers;

  /// Título de la página de recuperar contraseña
  ///
  /// In es, this message translates to:
  /// **'Recuperar Contraseña'**
  String get forgotPasswordTitle;

  /// Primer paso del proceso
  ///
  /// In es, this message translates to:
  /// **'Paso 1'**
  String get step1;

  /// Segundo paso del proceso
  ///
  /// In es, this message translates to:
  /// **'Paso 2'**
  String get step2;

  /// Tercer paso del proceso
  ///
  /// In es, this message translates to:
  /// **'Paso 3'**
  String get step3;

  /// Instrucción del paso 1
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu correo electrónico para recibir un código de verificación'**
  String get enterEmailToReceiveCode;

  /// Instrucción del paso 2
  ///
  /// In es, this message translates to:
  /// **'Ingresa el código de 6 dígitos enviado a {email}'**
  String enterCodeSentTo(String email);

  /// Instrucción del paso 3
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu nueva contraseña'**
  String get enterNewPassword;

  /// Botón para enviar código
  ///
  /// In es, this message translates to:
  /// **'Enviar Código'**
  String get sendCode;

  /// Botón para verificar código
  ///
  /// In es, this message translates to:
  /// **'Verificar Código'**
  String get verifyCode;

  /// Botón para restablecer contraseña
  ///
  /// In es, this message translates to:
  /// **'Restablecer Contraseña'**
  String get resetPassword;

  /// Campo de confirmar contraseña
  ///
  /// In es, this message translates to:
  /// **'Confirmar Contraseña'**
  String get confirmPassword;

  /// Mensaje de validación de contraseñas
  ///
  /// In es, this message translates to:
  /// **'Las contraseñas no coinciden'**
  String get passwordsDoNotMatch;

  /// Mensaje de código enviado
  ///
  /// In es, this message translates to:
  /// **'Código enviado exitosamente'**
  String get codeSentSuccessfully;

  /// Mensaje de código verificado
  ///
  /// In es, this message translates to:
  /// **'Código verificado exitosamente'**
  String get codeVerifiedSuccessfully;

  /// Mensaje de contraseña restablecida
  ///
  /// In es, this message translates to:
  /// **'Contraseña restablecida exitosamente'**
  String get passwordResetSuccessfully;

  /// Campo de código de verificación
  ///
  /// In es, this message translates to:
  /// **'Código de verificación'**
  String get verificationCode;

  /// Mensaje de validación de código
  ///
  /// In es, this message translates to:
  /// **'El código debe tener 6 dígitos'**
  String get codeMustBe6Digits;

  /// Campo de nueva contraseña
  ///
  /// In es, this message translates to:
  /// **'Nueva contraseña'**
  String get newPassword;

  /// Mensaje genérico de error de login
  ///
  /// In es, this message translates to:
  /// **'Error al iniciar sesión'**
  String get loginError;

  /// Mensaje de error de red
  ///
  /// In es, this message translates to:
  /// **'Error de conexión'**
  String get networkError;

  /// Mensaje de error del servidor
  ///
  /// In es, this message translates to:
  /// **'Error del servidor'**
  String get serverError;

  /// Mensaje de error cuando el email ya existe
  ///
  /// In es, this message translates to:
  /// **'El correo ya está registrado'**
  String get emailAlreadyExists;

  /// Mensaje genérico de error de registro
  ///
  /// In es, this message translates to:
  /// **'Error al registrarse'**
  String get registerError;

  /// Campo de número de tarjeta de crédito
  ///
  /// In es, this message translates to:
  /// **'Número de tarjeta'**
  String get cardNumber;

  /// Campo de fecha de vencimiento de tarjeta
  ///
  /// In es, this message translates to:
  /// **'MM/AA'**
  String get expiryDate;

  /// Campo de código de seguridad CVV
  ///
  /// In es, this message translates to:
  /// **'CVV'**
  String get cvv;

  /// Campo de nombre del titular de la tarjeta
  ///
  /// In es, this message translates to:
  /// **'Nombre en tarjeta'**
  String get cardholderName;

  /// Botón para procesar el pago
  ///
  /// In es, this message translates to:
  /// **'Pagar'**
  String get pay;

  /// Botón para seguir el pedido
  ///
  /// In es, this message translates to:
  /// **'Seguir'**
  String get trackOrder;

  /// Título de la página de seguimiento
  ///
  /// In es, this message translates to:
  /// **'Seguimiento de Pedido'**
  String get orderTracking;

  /// Título del header de seguimiento
  ///
  /// In es, this message translates to:
  /// **'Rastrea tu Pedido'**
  String get trackYourOrder;

  /// Descripción del proceso de seguimiento
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu número de orden y email para ver el estado de tu pedido'**
  String get trackOrderDescription;

  /// Título del formulario de información
  ///
  /// In es, this message translates to:
  /// **'Información del Pedido'**
  String get orderInformation;

  /// Campo de número de orden
  ///
  /// In es, this message translates to:
  /// **'Número de Orden'**
  String get orderNumber;

  /// Botón para buscar pedido
  ///
  /// In es, this message translates to:
  /// **'Buscar Pedido'**
  String get searchOrder;

  /// Mensaje de validación de campos vacíos
  ///
  /// In es, this message translates to:
  /// **'Por favor completa todos los campos'**
  String get completeAllFields;

  /// Mensaje de error al buscar orden
  ///
  /// In es, this message translates to:
  /// **'Error al buscar la orden: {error}'**
  String errorSearchingOrder(String error);

  /// Pregunta de ayuda
  ///
  /// In es, this message translates to:
  /// **'¿No tienes tu número de orden?'**
  String get noOrderNumber;

  /// Mensaje de ayuda para encontrar número de orden
  ///
  /// In es, this message translates to:
  /// **'Revisa tu email de confirmación o contacta a nuestro servicio al cliente.'**
  String get checkEmailOrContact;

  /// Palabra orden
  ///
  /// In es, this message translates to:
  /// **'Orden'**
  String get order;

  /// Título de la sección de información del pedido
  ///
  /// In es, this message translates to:
  /// **'Información del Pedido'**
  String get orderInfo;

  /// Etiqueta de fecha
  ///
  /// In es, this message translates to:
  /// **'Fecha'**
  String get date;

  /// Etiqueta del tipo de entrega
  ///
  /// In es, this message translates to:
  /// **'Tipo de Entrega'**
  String get deliveryTypeLabel;

  /// Etiqueta de total
  ///
  /// In es, this message translates to:
  /// **'Total'**
  String get total;

  /// Título de la sección de información del cliente
  ///
  /// In es, this message translates to:
  /// **'Información del Cliente'**
  String get customerInfo;

  /// Etiqueta de nombre completo
  ///
  /// In es, this message translates to:
  /// **'Nombre'**
  String get fullName;

  /// Etiqueta de tipo
  ///
  /// In es, this message translates to:
  /// **'Tipo'**
  String get type;

  /// Tipo de usuario registrado
  ///
  /// In es, this message translates to:
  /// **'Usuario registrado'**
  String get registeredUser;

  /// Valor no especificado
  ///
  /// In es, this message translates to:
  /// **'No especificado'**
  String get notSpecified;

  /// Tipo de cliente sin cuenta
  ///
  /// In es, this message translates to:
  /// **'Cliente sin cuenta'**
  String get guestCustomer;

  /// Título de la sección de productos
  ///
  /// In es, this message translates to:
  /// **'Productos Comprados'**
  String get purchasedProducts;

  /// Mensaje cuando no hay productos
  ///
  /// In es, this message translates to:
  /// **'No hay productos en esta orden'**
  String get noProductsInOrder;

  /// Etiqueta del total de la orden
  ///
  /// In es, this message translates to:
  /// **'Total de la Orden:'**
  String get orderTotal;

  /// Botón para pagar pedido
  ///
  /// In es, this message translates to:
  /// **'Pagar Pedido'**
  String get payOrder;

  /// Mensaje de funcionalidad en desarrollo
  ///
  /// In es, this message translates to:
  /// **'Funcionalidad de pago desde seguimiento en desarrollo'**
  String get paymentFeatureInDevelopment;

  /// Mensaje para producto sin nombre
  ///
  /// In es, this message translates to:
  /// **'Producto sin nombre'**
  String get productWithoutName;

  /// Etiqueta de cantidad
  ///
  /// In es, this message translates to:
  /// **'Cantidad'**
  String get quantity;

  /// Etiqueta de precio unitario
  ///
  /// In es, this message translates to:
  /// **'Precio Unit.'**
  String get unitPrice;

  /// Mensaje para fecha desconocida
  ///
  /// In es, this message translates to:
  /// **'Fecha desconocida'**
  String get unknownDate;

  /// Tipo de entrega a domicilio
  ///
  /// In es, this message translates to:
  /// **'Domicilio'**
  String get homeDelivery;

  /// Tipo de entrega recoger en tienda
  ///
  /// In es, this message translates to:
  /// **'Recoger en tienda'**
  String get pickupAtStore;

  /// Estado pendiente
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get statusPending;

  /// Estado en proceso
  ///
  /// In es, this message translates to:
  /// **'En proceso'**
  String get statusProcessing;

  /// Estado finalizado
  ///
  /// In es, this message translates to:
  /// **'Finalizado'**
  String get statusPaid;

  /// Estado fallido
  ///
  /// In es, this message translates to:
  /// **'Fallido'**
  String get statusFailed;

  /// Estado cancelado
  ///
  /// In es, this message translates to:
  /// **'Cancelado'**
  String get statusCancelled;

  /// Título de la sección de categorías
  ///
  /// In es, this message translates to:
  /// **'Categorias'**
  String get categoriesTitle;

  /// Subtítulo de la sección de categorías
  ///
  /// In es, this message translates to:
  /// **'La magia comienza con una buena elección'**
  String get categoriesSubtitle;

  /// Mensaje cuando no hay categorías
  ///
  /// In es, this message translates to:
  /// **'No se encontraron categorías'**
  String get noCategoriesFound;

  /// Sugerencia para buscar con otro término
  ///
  /// In es, this message translates to:
  /// **'Intenta con otro término de búsqueda'**
  String get tryAnotherSearchTerm;

  /// Texto para ver productos de una categoría
  ///
  /// In es, this message translates to:
  /// **'Ver productos'**
  String get viewProducts;

  /// Placeholder para buscar productos
  ///
  /// In es, this message translates to:
  /// **'Buscar productos...'**
  String get searchProducts;

  /// Mensaje cuando no hay productos
  ///
  /// In es, this message translates to:
  /// **'No se encontraron productos'**
  String get noProductsFound;

  /// Mensaje de carga del carrito
  ///
  /// In es, this message translates to:
  /// **'Cargando carrito...'**
  String get loadingCart;

  /// Título del carrito
  ///
  /// In es, this message translates to:
  /// **'Mi Carrito'**
  String get myCart;

  /// Palabra producto en singular
  ///
  /// In es, this message translates to:
  /// **'producto'**
  String get product;

  /// Palabra productos en plural
  ///
  /// In es, this message translates to:
  /// **'productos'**
  String get products;

  /// Mensaje al crear orden
  ///
  /// In es, this message translates to:
  /// **'Creando tu orden...'**
  String get creatingOrder;

  /// Mensaje al procesar pago
  ///
  /// In es, this message translates to:
  /// **'Procesando pago con PayU...'**
  String get processingPayment;

  /// Título de pago exitoso
  ///
  /// In es, this message translates to:
  /// **'¡Pago Exitoso!'**
  String get paymentSuccessful;

  /// Mensaje de pago exitoso
  ///
  /// In es, this message translates to:
  /// **'Tu pago se ha procesado correctamente.'**
  String get paymentSuccessMessage;

  /// Título de pago rechazado
  ///
  /// In es, this message translates to:
  /// **'Pago Rechazado'**
  String get paymentRejected;

  /// Mensaje de pago rechazado
  ///
  /// In es, this message translates to:
  /// **'No se pudo procesar el pago. Por favor intenta nuevamente.'**
  String get paymentRejectedMessage;

  /// Título de error en pago
  ///
  /// In es, this message translates to:
  /// **'Error en el Pago'**
  String get paymentError;

  /// Mensaje de error en pago
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error al procesar tu pago: {error}'**
  String paymentErrorMessage(String error);

  /// Título de error al crear orden
  ///
  /// In es, this message translates to:
  /// **'Error al Crear Orden'**
  String get orderCreationError;

  /// Mensaje de error al crear orden
  ///
  /// In es, this message translates to:
  /// **'No se pudo crear la orden. Por favor intenta nuevamente.'**
  String get orderCreationErrorMessage;

  /// Título de error genérico
  ///
  /// In es, this message translates to:
  /// **'Error'**
  String get error;

  /// Mensaje de error inesperado
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error inesperado: {error}'**
  String unexpectedError(String error);

  /// Botón aceptar
  ///
  /// In es, this message translates to:
  /// **'Aceptar'**
  String get accept;

  /// Botón entendido
  ///
  /// In es, this message translates to:
  /// **'Entendido'**
  String get understood;

  /// Mensaje de carga de datos
  ///
  /// In es, this message translates to:
  /// **'Cargando datos...'**
  String get loadingData;

  /// Subtítulo del formulario de cliente
  ///
  /// In es, this message translates to:
  /// **'Completa tus datos de entrega'**
  String get completeDeliveryData;

  /// Error cuando el nombre está vacío
  ///
  /// In es, this message translates to:
  /// **'El nombre es requerido'**
  String get nameRequired;

  /// Error cuando el nombre es muy corto
  ///
  /// In es, this message translates to:
  /// **'Nombre muy corto (mín. 3 caracteres)'**
  String get nameTooShort;

  /// Error cuando el email está vacío
  ///
  /// In es, this message translates to:
  /// **'El email es requerido'**
  String get emailRequired;

  /// Error cuando el email es inválido
  ///
  /// In es, this message translates to:
  /// **'Email inválido'**
  String get invalidEmail;

  /// Error cuando el teléfono está vacío
  ///
  /// In es, this message translates to:
  /// **'El teléfono es requerido'**
  String get phoneRequired;

  /// Error cuando el teléfono es inválido
  ///
  /// In es, this message translates to:
  /// **'Teléfono inválido (mín. 7 dígitos)'**
  String get invalidPhone;

  /// Error cuando la dirección está vacía
  ///
  /// In es, this message translates to:
  /// **'La dirección es requerida'**
  String get addressRequired;

  /// Error cuando la dirección es muy corta
  ///
  /// In es, this message translates to:
  /// **'Dirección muy corta (mín. 10 caracteres)'**
  String get addressTooShort;

  /// Error cuando la ciudad está vacía
  ///
  /// In es, this message translates to:
  /// **'La ciudad es requerida'**
  String get cityRequired;

  /// Error cuando la ciudad es muy corta
  ///
  /// In es, this message translates to:
  /// **'Ciudad muy corta'**
  String get cityTooShort;

  /// Mensaje cuando hay errores en el formulario
  ///
  /// In es, this message translates to:
  /// **'Por favor corrige los errores antes de continuar'**
  String get fixErrorsBeforeContinue;

  /// Label para dirección de entrega
  ///
  /// In es, this message translates to:
  /// **'Dirección de Entrega'**
  String get deliveryAddress;

  /// Label para ciudad
  ///
  /// In es, this message translates to:
  /// **'Ciudad'**
  String get cityLabel;

  /// Checkbox para guardar datos
  ///
  /// In es, this message translates to:
  /// **'Guardar mis datos para la próxima vez'**
  String get saveDataForNextTime;

  /// Placeholder para campos del formulario
  ///
  /// In es, this message translates to:
  /// **'Ingresa tu {field}'**
  String enterYour(String field);

  /// Título de orden creada
  ///
  /// In es, this message translates to:
  /// **'¡Orden Creada!'**
  String get orderCreated;

  /// Título de detalles de la orden
  ///
  /// In es, this message translates to:
  /// **'Detalles de tu Orden'**
  String get orderDetails;

  /// Mensaje de orden creada exitosamente
  ///
  /// In es, this message translates to:
  /// **'Tu orden ha sido creada exitosamente'**
  String get orderCreatedSuccessfully;

  /// Etiqueta para el total
  ///
  /// In es, this message translates to:
  /// **'Total:'**
  String get totalLabel;

  /// Mensaje de pago seguro
  ///
  /// In es, this message translates to:
  /// **'Pago seguro con PayU'**
  String get securePaymentWith;

  /// Error de checksum de tarjeta inválido
  ///
  /// In es, this message translates to:
  /// **'Número de tarjeta inválido (checksum)'**
  String get invalidCardChecksum;

  /// Error de número de tarjeta requerido
  ///
  /// In es, this message translates to:
  /// **'El número de tarjeta es requerido'**
  String get cardNumberRequired;

  /// Error de número de tarjeta inválido
  ///
  /// In es, this message translates to:
  /// **'Número de tarjeta inválido'**
  String get invalidCardNumber;

  /// Error de solo letras y espacios
  ///
  /// In es, this message translates to:
  /// **'Solo letras y espacios'**
  String get onlyLettersAndSpaces;

  /// Error de fecha requerida
  ///
  /// In es, this message translates to:
  /// **'La fecha es requerida'**
  String get expiryDateRequired;

  /// Error de formato de fecha inválido
  ///
  /// In es, this message translates to:
  /// **'Formato inválido (MM/AA)'**
  String get invalidExpiryFormat;

  /// Error de tarjeta vencida
  ///
  /// In es, this message translates to:
  /// **'Tarjeta vencida'**
  String get cardExpired;

  /// Error de CVV requerido
  ///
  /// In es, this message translates to:
  /// **'El CVV es requerido'**
  String get cvvRequired;

  /// Error de longitud CVV para Amex
  ///
  /// In es, this message translates to:
  /// **'CVV debe tener 4 dígitos (Amex)'**
  String get cvvAmexLength;

  /// Error de longitud CVV
  ///
  /// In es, this message translates to:
  /// **'CVV debe tener 3 dígitos'**
  String get cvvLength;

  /// Mensaje de protección SSL
  ///
  /// In es, this message translates to:
  /// **'Tu información está protegida con encriptación SSL'**
  String get sslProtection;

  /// Etiqueta de titular en vista previa
  ///
  /// In es, this message translates to:
  /// **'TITULAR'**
  String get cardholder;

  /// Etiqueta de vencimiento en vista previa
  ///
  /// In es, this message translates to:
  /// **'VENCE'**
  String get expires;

  /// Placeholder para nombre del titular
  ///
  /// In es, this message translates to:
  /// **'NOMBRE APELLIDO'**
  String get cardholderPlaceholder;

  /// Placeholder para fecha de expiración
  ///
  /// In es, this message translates to:
  /// **'MM/AA'**
  String get expiryPlaceholder;

  /// Placeholder para ingresar campo
  ///
  /// In es, this message translates to:
  /// **'Ingresa {field}'**
  String enterField(String field);

  /// Mensaje de error ocurrido
  ///
  /// In es, this message translates to:
  /// **'Ocurrió un error'**
  String get anErrorOccurred;

  /// Error de nombre requerido
  ///
  /// In es, this message translates to:
  /// **'El nombre es requerido'**
  String get firstNameRequired;

  /// Error de apellido requerido
  ///
  /// In es, this message translates to:
  /// **'El apellido es requerido'**
  String get lastNameRequired;

  /// Mensaje de perfil actualizado
  ///
  /// In es, this message translates to:
  /// **'Perfil actualizado exitosamente'**
  String get profileUpdatedSuccessfully;

  /// Mensaje de error al actualizar
  ///
  /// In es, this message translates to:
  /// **'Error al actualizar perfil'**
  String get errorUpdatingProfile;

  /// Instrucción para confirmar eliminación
  ///
  /// In es, this message translates to:
  /// **'Para confirmar, escribe \"ELIMINAR\" en el campo de abajo:'**
  String get deleteConfirmInstruction;

  /// Placeholder para campo de confirmación
  ///
  /// In es, this message translates to:
  /// **'Escribe \"ELIMINAR\" aquí'**
  String get typeDeleteHere;

  /// Mensaje de cuenta eliminada
  ///
  /// In es, this message translates to:
  /// **'Cuenta eliminada exitosamente'**
  String get accountDeletedSuccessfully;

  /// Mensaje de error al eliminar cuenta
  ///
  /// In es, this message translates to:
  /// **'Error al eliminar cuenta'**
  String get errorDeletingAccount;

  /// Mensaje de error al cargar historial de órdenes
  ///
  /// In es, this message translates to:
  /// **'Error al cargar el historial de órdenes'**
  String get errorLoadingOrderHistory;

  /// Mensaje de carga del historial
  ///
  /// In es, this message translates to:
  /// **'Cargando historial de órdenes...'**
  String get loadingOrderHistory;

  /// Mensaje cuando no hay órdenes
  ///
  /// In es, this message translates to:
  /// **'No tienes órdenes aún'**
  String get noOrdersYet;

  /// Número de orden con hash
  ///
  /// In es, this message translates to:
  /// **'Orden #{orderNumber}'**
  String orderNumberWithHash(String orderNumber);

  /// Total de la orden con monto
  ///
  /// In es, this message translates to:
  /// **'Total: S/ {amount}'**
  String totalWithAmount(String amount);

  /// Estado de la orden con valor
  ///
  /// In es, this message translates to:
  /// **'Estado: {status}'**
  String statusWithValue(String status);

  /// Etiqueta de productos en historial
  ///
  /// In es, this message translates to:
  /// **'Productos:'**
  String get productsLabel;

  /// Estado pendiente
  ///
  /// In es, this message translates to:
  /// **'Pendiente'**
  String get orderStatusPending;

  /// Estado en proceso
  ///
  /// In es, this message translates to:
  /// **'En proceso'**
  String get orderStatusProcessing;

  /// Estado finalizado
  ///
  /// In es, this message translates to:
  /// **'Finalizado'**
  String get orderStatusPaid;

  /// Estado fallido
  ///
  /// In es, this message translates to:
  /// **'Fallido'**
  String get orderStatusFailed;

  /// Estado cancelado
  ///
  /// In es, this message translates to:
  /// **'Cancelado'**
  String get orderStatusCancelled;

  /// Mensaje de pago rechazado con error
  ///
  /// In es, this message translates to:
  /// **'Pago rechazado: {error}'**
  String paymentRejectedWithError(String error);

  /// Error al procesar pago
  ///
  /// In es, this message translates to:
  /// **'Error procesando pago: {error}'**
  String errorProcessingPayment(String error);

  /// Error al iniciar pago
  ///
  /// In es, this message translates to:
  /// **'Error iniciando pago: {error}'**
  String errorInitiatingPayment(String error);

  /// Mensaje cuando no hay pedidos en admin
  ///
  /// In es, this message translates to:
  /// **'No hay pedidos para mostrar.'**
  String get noOrdersToDisplay;

  /// Número de pedido en vista admin
  ///
  /// In es, this message translates to:
  /// **'Pedido #{orderNumber}'**
  String orderNumberAdmin(String orderNumber);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
