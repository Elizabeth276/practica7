import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practica7/providers/theme_provider.dart';
import 'package:practica7/screens/dashboard_screen.dart';
import 'package:practica7/screens/new_actividad_screen.dart';
import 'package:practica7/screens/new_empleado_screen.dart';
import 'package:practica7/screens/new_incidencia_screen.dart';
import 'package:practica7/screens/onboarding_screen.dart';
import 'package:practica7/screens/profile_screen.dart';
import 'package:practica7/screens/verify_email_screen.dart';
import 'package:provider/provider.dart';
import 'package:practica7/screens/splash_screen.dart';
import 'package:practica7/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: CaisesApp(),
    );
  }
}

class CaisesApp extends StatelessWidget {
  const CaisesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeProvider theme = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Caises cortazar',
      theme: theme.getThemeData(),
      home: const SplashScreen(),
      routes: {
        '/login': (BuildContext context) => LoginScreen(),
        '/verify': (BuildContext context) => VerifyEmailScreen(),
        '/onboarding': (BuildContext context) => OnboardingScreen(),
        '/dash': (BuildContext context) => DashboardScreen(),
        '/profile': (BuildContext context) => ProfileScreen(),
        '/newEmpleado': (BuildContext context) => NewEmpleadoScreen(),
        '/newIncidencia': (BuildContext context) => NewIncidenciaScreen(),
        '/newActividad': (BuildContext context) => NewActividadScreen(),
      },
    );
  }
}
