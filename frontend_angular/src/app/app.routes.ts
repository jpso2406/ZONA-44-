import { Routes } from '@angular/router';
import { Home } from './Pages/home/home';
import { Menu } from './Pages/menu/menu';
import { OrderComponent } from './Pages/order/order';
import { PagoComponent } from './Pages/pago/pago';
import { PerfilComponent } from './Pages/Perfil/perfil';
import { LoginComponent } from './Pages/auth/login/login';
import { RegisterComponent } from './Pages/auth/register/register';
import { ForgotPasswordComponent } from './Pages/auth/forgot-password/forgot-password';
import { AuthGuard } from './Guards/auth.guard';
import { AdminLayoutComponent } from './Pages/admin/admin-layout/admin-layout';
import { AdminDashboardComponent } from './Pages/admin/admin-dashboard/admin-dashboard';
import { AdminGruposComponent } from './Pages/admin/admin-grupos/admin-grupos';
import { AdminProductosComponent } from './Pages/admin/admin-productos/admin-productos';
import { AdminPromocionesComponent } from './Pages/admin/admin-promociones/admin-promociones';
import { AdminPedidosComponent } from './Pages/admin/admin-pedidos/admin-pedidos';

export const routes: Routes = [
    {
        path: '',
        component: Home,
    },
    {
        path: 'menu',
        component: Menu,
    },
    {
        path: 'order',
        component: OrderComponent,
    },
    {
        path: 'pago',
        component: PagoComponent,
    },
    {
        path: 'perfil',
        component: PerfilComponent,
        canActivate: [AuthGuard]
    },
    {
        path: 'login',
        component: LoginComponent,
    },
    {
        path: 'register',
        component: RegisterComponent,
    },
    {
        path: 'forgot-password',
        component: ForgotPasswordComponent,
    }
    ,
    {
        path: 'admin',
        component: AdminLayoutComponent,
        canActivate: [AuthGuard],
        children: [
            {
                path: '',
                component: AdminDashboardComponent
            },
            {
                path: 'grupos',
                component: AdminGruposComponent
            },
            {
                path: 'productos',
                component: AdminProductosComponent
            },
            {
                path: 'promociones',
                component: AdminPromocionesComponent
            },
            {
                path: 'pedidos',
                component: AdminPedidosComponent
            }
        ]
    }
];
