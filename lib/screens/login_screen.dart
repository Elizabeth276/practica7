import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:practica7/firebase/email_authentication.dart';
import 'package:practica7/providers/login_provider.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../firebase/google_authentication.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => new LoginProvider(),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController txtMailSignIn = TextEditingController();
  TextEditingController txtPwdSignIn = TextEditingController();

  TextEditingController txtUser = TextEditingController();
  TextEditingController txtMailSignUp = TextEditingController();
  TextEditingController txtPwdSignUp = TextEditingController();

  EmailAuthentication? _emailAuth;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailAuth = EmailAuthentication();
  }

  @override
  Widget build(BuildContext context) {
    LoginProvider loginProvider = Provider.of<LoginProvider>(context);

    return Stack(
      children: [
        //HEADER PAGE
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Container(
            height: 300,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/fondo_login.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 90, left: 20),
              color: const Color(0xFF3b5999).withOpacity(.85),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Bienvenido',
                      style: TextStyle(
                        fontSize: 25,
                        letterSpacing: 2,
                        color: Colors.yellow[700],
                      ),
                      children: [
                        TextSpan(
                          text: loginProvider.getIsSignUpScreen() == true
                              ? ' Caises App'
                              : ' de vuelta',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    loginProvider.getIsSignUpScreen() == true
                        ? 'Registrate para continuar!'
                        : 'Inicia sesión para continuar!',
                    style: const TextStyle(
                      color: Colors.white,
                      letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        buildBottomHalfContainer(true, loginProvider),
        //MAIN CONTAINER FRO LOGIN AND SIGNUP
        AnimatedPositioned(
          duration: const Duration(milliseconds: 700),
          curve: Curves.bounceInOut,
          top: loginProvider.getIsSignUpScreen() == true ? 200 : 230,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 700),
            curve: Curves.bounceInOut,
            height: loginProvider.getIsSignUpScreen() == true ? 380 : 240,
            padding: const EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width - 40,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          loginProvider.setIsSiginupScreen(false);
                        },
                        child: Column(
                          children: [
                            Text(
                              'INICIAR SESIÓN',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color:
                                    loginProvider.getIsSignUpScreen() == false
                                        ? const Color(0XFF09126C)
                                        : const Color(0XFFA7BCC7),
                              ),
                            ),
                            if (loginProvider.getIsSignUpScreen() == false)
                              Container(
                                margin: const EdgeInsets.only(top: 3),
                                height: 2,
                                width: 100,
                                color: Colors.orange,
                              ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          loginProvider.setIsSiginupScreen(true);
                        },
                        child: Column(
                          children: [
                            Text(
                              'REGISTRARSE',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: loginProvider.getIsSignUpScreen() == true
                                    ? const Color(0XFF09126C)
                                    : const Color(0XFFA7BCC7),
                              ),
                            ),
                            if (loginProvider.getIsSignUpScreen() == true)
                              Container(
                                margin: const EdgeInsets.only(top: 3),
                                height: 2,
                                width: 100,
                                color: Colors.orange,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (loginProvider.getIsSignUpScreen() == true)
                    buidlSignupSection(),
                  if (loginProvider.getIsSignUpScreen() == false)
                    buildSigninSection()
                ],
              ),
            ),
          ),
        ),
        buildBottomHalfContainer(false, loginProvider),
        //BUTTON GOOGLE
        Positioned(
          top: MediaQuery.of(context).size.height - 120,
          right: 0,
          left: 0,
          child: Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: Text(
                  loginProvider.getIsSignUpScreen() == true
                      ? 'O registrate con'
                      : 'Inicia sesión con',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: SocialLoginButton(
                  buttonType: SocialLoginButtonType.google,
                  text: 'Continuar con Google',
                  onPressed: () async {
                    User? user = await GoogleAuthenticator.iniciarSesion(
                        context: context);
                    var name = user?.displayName;
                    var id = user?.email;
                    Navigator.pushReplacementNamed(context, '/onboarding');
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container buildSigninSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          buidlTextField(const Icon(Icons.email_outlined),
              'example@example.com', false, true, txtMailSignIn),
          buidlTextField(
              const Icon(Icons.key), '***********', true, false, txtPwdSignIn)
        ],
      ),
    );
  }

  Container buidlSignupSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          buidlTextField(
              const Icon(Icons.person), 'Usuario', false, false, txtUser),
          buidlTextField(const Icon(Icons.email_outlined), 'Correo eléctronico',
              false, true, txtMailSignUp),
          buidlTextField(
              const Icon(Icons.key), 'Contraseña', true, false, txtPwdSignUp),
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            width: 200,
            child: RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                  text: 'Al registrarte, aceptas nuestros ',
                  style: TextStyle(
                    color: Color(0XFFA7BCC7),
                  ),
                  children: [
                    TextSpan(
                        text: 'terminos y condiciones',
                        style: TextStyle(color: Colors.orange))
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBottomHalfContainer(bool showShadow, LoginProvider provider) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 700),
      curve: Curves.bounceInOut,
      top: provider.getIsSignUpScreen() == true ? 535 : 430,
      right: 0,
      left: 0,
      child: Center(
        child: Container(
          height: 90,
          width: 90,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: [
              if (showShadow)
                BoxShadow(
                    color: Colors.black.withOpacity(.3),
                    spreadRadius: 1.5,
                    blurRadius: 10),
            ],
          ),
          child: !showShadow
              ? GestureDetector(
                  onTap: () async {
                    if (provider.getIsSignUpScreen() == true) {
                      _emailAuth
                          ?.createUserWithEmailAndPassword(
                              email: txtMailSignUp.text,
                              password: txtPwdSignUp.text)
                          .then((value) {
                        if (value == true) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Verificación de email'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: const <Widget>[
                                        Text(
                                            'Un correo de verificacion ha sido enviado al correo proporcionado'),
                                        Text(
                                            'Una vez que verifiques tu cuenta, ve a la pantalla de inicio de sesión e ingresa tus credenciales'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Aceptar'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        } else {
                          print('No se pudo crear el usuario');
                        }
                      });
                    } else if (provider.getIsSignUpScreen() == false) {
                      final fcmToken =
                          await FirebaseMessaging.instance.getToken();
                      print('TOKEN NOTIFICACIONES');
                      print('TOKEN: ${fcmToken}');
                      _emailAuth
                          ?.signInWithEmailAndPassword(
                        email: txtMailSignIn.text,
                        password: txtPwdSignIn.text,
                      )
                          .then((value) {
                        if (value) {
                          Navigator.pushReplacementNamed(
                              context, '/onboarding');
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Credenciales incorrectas'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: const <Widget>[
                                        Text('¡Ups! Algo no ha salido bien...'),
                                        Text(
                                            'Usuario y/o contraseña incorrectos, intenta de nuevo'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Aceptar'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        }
                      });
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.orange.shade200, Colors.red.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.3),
                            spreadRadius: 1,
                            blurRadius: 1),
                      ],
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                )
              : const Center(),
        ),
      ),
    );
  }

  Widget buidlTextField(Icon icon, String hintText, bool isPwd, bool isEmail,
      TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextField(
        controller: controller,
        obscureText: isPwd,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: icon,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0XFFA7BCC7),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(35),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0XFFA7BCC7),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(35),
            ),
          ),
          contentPadding: EdgeInsets.all(10),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 14,
            color: Color(0XFFA7BCC7),
          ),
        ),
      ),
    );
  }
}
