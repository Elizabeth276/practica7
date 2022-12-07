import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:practica7/firebase/google_authentication.dart';
import 'package:practica7/providers/theme_provider.dart';
import 'package:practica7/settings/styles_settings.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen> {
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final tema = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: Drawer(
        backgroundColor: Theme.of(context).primaryColor,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/img/fondo_login.png'),
                    fit: BoxFit.cover,
                    opacity: 0.8,
                    colorFilter:
                        ColorFilter.mode(Colors.black87, BlendMode.darken)),
              ),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: CircleAvatar(
                  backgroundImage: user != null
                      ? NetworkImage(user!.photoURL != null
                              ? '${user!.photoURL}'
                              : 'https://cdn-icons-png.flaticon.com/512/149/149071.png')
                          as ImageProvider
                      : const AssetImage('assets/img/user.png'),
                ),
              ),
              accountName: user != null
                  ? Text(
                      user!.displayName == null
                          ? 'Nombre no encontrado'
                          : '${user!.displayName}',
                      style: const TextStyle(fontFamily: 'Raleway'),
                    )
                  : const Text(''),
              accountEmail: user != null
                  ? Text(
                      '${user!.email}',
                      style: const TextStyle(fontFamily: 'Raleway'),
                    )
                  : const Text(''),
            ),
            ListTile(
              leading: const Icon(Icons.person_add_alt),
              trailing: const Icon(Icons.chevron_right),
              title: const Text(
                'Registrar nuevo empleado',
                style: TextStyle(color: Colors.white, fontFamily: 'Raleway'),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/newEmpleado');
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_alt),
              trailing: const Icon(Icons.chevron_right),
              title: const Text(
                'Registrar incidencias',
                style: TextStyle(color: Colors.white, fontFamily: 'Raleway'),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/newIncidencia');
              },
            ),
            ListTile(
              leading: const Icon(Icons.view_agenda_outlined),
              trailing: const Icon(Icons.chevron_right),
              title: const Text(
                'Registrar actividades',
                style: TextStyle(color: Colors.white, fontFamily: 'Raleway'),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/newIncidencia');
              },
            ),
            ListTile(
              leading: const Icon(Icons.sunny),
              title: const Text(
                'Tema de día',
                style: TextStyle(color: Colors.white, fontFamily: 'Raleway'),
              ),
              onTap: () {
                tema.setthemData(lightTheme());
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text(
                'Tema de noche',
                style: TextStyle(color: Colors.white, fontFamily: 'Raleway'),
              ),
              onTap: () {
                tema.setthemData(darkTheme());
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.white, fontFamily: 'Raleway'),
              ),
              onTap: () async {
                bool ban = await GoogleAuthenticator.siginOutGoogle();
                if (ban) Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildImageCard('assets/img/card1.png', 'Registro de empleados',
                  '/newEmpleado'),
              const SizedBox(height: 10),
              _buildImageCard('assets/img/card2.png', 'Registro de incidencias',
                  '/newIncidencia'),
              const SizedBox(height: 10),
              _buildImageCard('assets/img/card3.png',
                  'Registra tus actividades', '/newActividad'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCard(String img, String title, String url) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Ink.image(
            image: AssetImage(img),
            height: 240,
            fit: BoxFit.cover,
            child: InkWell(onTap: () {
              Navigator.pushNamed(context, url);
            }),
          ),
          Container(
            color: Colors.black.withOpacity(.6),
            height: 60,
            child: ListTile(
              title: Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Raleway'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
