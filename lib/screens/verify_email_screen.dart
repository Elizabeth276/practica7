import 'package:flutter/material.dart';
import 'package:practica7/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';

import '../providers/verify_email_provider.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => new VerifyEmailProvider(),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: const Center(child: Text('¡Verifica tu correo!')),
        ),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4,
            child: Column(
              children: [
                const Text(
                  'Un correo de verificación ha sido enviado al correo que proporcionaste',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width, 40)),
                  onPressed: () {},
                  icon: const Icon(Icons.email_outlined),
                  label: const Text('Reenviar correo'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  style: TextButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width, 40)),
                  child: const Text('Cancelar'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
