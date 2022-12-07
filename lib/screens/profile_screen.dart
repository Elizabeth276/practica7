import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practica7/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider(),
      child: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    ProfileProvider provider = Provider.of<ProfileProvider>(context);
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColorDark,
                  Theme.of(context).primaryColor,
                ],
                begin: FractionalOffset.bottomCenter,
                end: FractionalOffset.topCenter),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 45),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back,
                          color: Theme.of(context).primaryColorLight,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Mi Perfil',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorLight,
                      fontSize: 30,
                      fontFamily: 'Raleway',
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (user!.displayName != null)
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColorDark),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.g_mobiledata_rounded),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Autenticación por Google',
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Theme.of(context).primaryColorDark),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Autenticación por Email',
                            style: TextStyle(
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w600),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 30),
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 4,
                        color: Theme.of(context).backgroundColor,
                      ),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Colors.black.withOpacity(0.1),
                          offset: const Offset(0, 10),
                        )
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: user != null
                            ? NetworkImage(user!.photoURL != null
                                    ? '${user!.photoURL}'
                                    : 'https://cdn-icons-png.flaticon.com/512/149/149071.png')
                                as ImageProvider
                            : const AssetImage('assets/img/user.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 35),
                  Center(
                    child: user != null
                        ? Text(
                            user!.displayName == null
                                ? 'Nombre no encontrado'
                                : '${user!.displayName}',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Raleway',
                              letterSpacing: 2,
                            ),
                            textAlign: TextAlign.center,
                          )
                        : const Text(''),
                  ),
                  const SizedBox(height: 60),
                  buildTextField(
                      'Id usuario',
                      user != null ? '${user!.uid}' : 'Id no encontrado',
                      false),
                  buildTextField(
                      'Correo electrónico',
                      user != null ? '${user!.email}' : 'Email no encontrado',
                      false),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () {
                      user!.displayName != null
                          ? provider.setIsAuthGoogle(true)
                          : provider.setIsAuthGoogle(false);

                      if (provider.getIsAuthGoogle() == true) {
                        const snackBar = SnackBar(
                          content: Text(
                              'No puedes actualizar la foto del proveedor con el que iniciaste sesión'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        print('AUTH EMAIL');
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.3),
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                    child: Text(
                      'CAMBIAR FOTO',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        fontFamily: 'Raleway',
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.26),
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                    child: Text(
                      'GUARDAR CAMBIOS',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        fontFamily: 'Raleway',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget buildTextField(String labelText, String placeholder, bool enabled
      /*TextEditingController controller*/
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: TextField(
        //controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 5),
            focusColor: Colors.red,
            labelText: labelText,
            hintText: placeholder,
            floatingLabelBehavior: FloatingLabelBehavior.always),
      ),
    );
  }
}
