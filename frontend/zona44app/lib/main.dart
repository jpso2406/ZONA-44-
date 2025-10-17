import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:zona44app/exports/exports.dart';
import 'package:zona44app/l10n/app_localizations.dart';
import 'features/Home/bloc/home_bloc.dart';
import 'features/Carrito/bloc/carrito_bloc.dart';
import 'features/Inicio/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('es', '');

  @override
  void initState() {
    super.initState();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString('locale');
    if (savedLocale != null) {
      setState(() {
        _locale = Locale(savedLocale);
      });
    }
  }

  void changeLocale(Locale locale) async {
    setState(() {
      _locale = locale;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (_) => HomeBloc()),
        BlocProvider<CarritoBloc>(create: (_) => CarritoBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Zona44',
        locale: _locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('es', ''), // Español
          Locale('en', ''), // Inglés
        ],
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const Home(),
        },
        builder: (context, child) {
          return LocaleProvider(
            locale: _locale,
            changeLocale: changeLocale,
            child: child!,
          );
        },
      ),
    );
  }
}

class LocaleProvider extends InheritedWidget {
  final Locale locale;
  final Function(Locale) changeLocale;

  const LocaleProvider({
    super.key,
    required this.locale,
    required this.changeLocale,
    required super.child,
  });

  static LocaleProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LocaleProvider>()!;
  }

  @override
  bool updateShouldNotify(LocaleProvider oldWidget) {
    return locale != oldWidget.locale;
  }
}
