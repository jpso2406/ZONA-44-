//Exportacion de la url de api
export '../config/backend_config.dart';

// Exportaciones de modelos
export '../models/producto.dart';
export '../models/grupo.dart';
export '../models/carrito.dart';

// Exportaciones de la página del carrito y sus widgets
export '../features/Carrito/carrito.dart';
export '../features/Carrito/widgets/cart_item_card.dart';
export '../features/Carrito/widgets/cart_summary.dart';
export '../features/Carrito/widgets/customer_form_dialog.dart';
export '../features/Carrito/widgets/payment_form_dialog.dart';
export '../features/Carrito/widgets/payment_result_dialog.dart';
export '../features/Carrito/widgets/cart_empty.dart';

// Exportaciones del Home (navegacion de la pagina)
export '../features/Home/home.dart';

// Exportaciones de la páginas inicio
export '../features/Inicio/Inicio.dart';

// Exportaciones de Menu
export '../features/menu/menu.dart';
export '../features/menu/views/Grupo/grupo_view.dart'; 
export '../features/menu/views/Producto/producto_view.dart';

// Exportaciones del Perfil(navegacion de la pagina)
export '../features/Perfil/perfil.dart';
export '../features/Perfil/views/perfil_success.dart';
export '../features/Perfil/views/perfil_loading.dart';
export '../features/Perfil/views/perfil_failure.dart';

// Exportaciones de services
export '../services/menu_service.dart';
export '../services/order_service.dart';

// Exportaciones de los widgets
export '../features/menu/views/Producto/widgets/card_product.dart';
export '../features/menu/views/Grupo/widgets/card_group.dart';
export '../widgets/nav_home.dart';