import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:practica7/models/model_actividad.dart';
import 'package:practica7/providers/actividades_provider.dart';
import 'package:provider/provider.dart';

class NewActividadScreen extends StatelessWidget {
  const NewActividadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificacionesProvider(),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: const Text('Registro de actividades'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: _NewActividad(),
      ),
    );
  }
}

class _NewActividad extends StatefulWidget {
  _NewActividad({
    Key? key,
  }) : super(key: key);
  @override
  State<_NewActividad> createState() => _NewActividadState();
}

class _NewActividadState extends State<_NewActividad> {
  TextEditingController txtNombre = TextEditingController();
  TextEditingController txtDescripcion = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NotificacionesProvider>(context);
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            const _Encabezado(),
            const SizedBox(height: 10),
            _buildForm(context, provider),
            _buildFormNotifications(context, provider)
          ],
        ),
      ),
    );
  }

  Container _buildForm(BuildContext context, provider) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      height: MediaQuery.of(context).size.height * 0.45,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            buidlTextField(const Icon(Icons.task), 'Nombre de la actividad',
                false, false, 1, txtNombre),
            const SizedBox(height: 10),
            buidlTextField(const Icon(Icons.task), 'Descripcion', false, false,
                5, txtDescripcion),
            const SizedBox(height: 10),
            _buildButtonRegistro(context),
            _buildButtonCancelar(context),
          ],
        ),
      ),
    );
  }

  Container _buildFormNotifications(BuildContext context, provider) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      height: MediaQuery.of(context).size.height * 0.13,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Recibir notificaciones',
              style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor),
            ),
            _buildCheckBox(context, provider),
          ],
        ),
      ),
    );
  }

  Switch _buildCheckBox(BuildContext context, provider) {
    return Switch(
      activeColor: Theme.of(context).primaryColor,
      value: provider.getNotificaciones(),
      onChanged: (value) {
        provider.setNotificacion(value);
      },
    );
  }

  Container _buildButtonCancelar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        height: 40.0,
        onPressed: () {
          Navigator.pop(context);
        },
        color: Theme.of(context).secondaryHeaderColor,
        child: Text('Cancelar',
            style: TextStyle(color: Theme.of(context).primaryColorLight)),
      ),
    );
  }

  Container _buildButtonRegistro(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        height: 40.0,
        onPressed: () {
          createActividad(txtNombre.text, txtDescripcion.text);
        },
        color: Theme.of(context).primaryColor,
        child: const Text('Registrar actividad',
            style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Future createActividad(String nombre, String descripcion) async {
    final docActividad =
        FirebaseFirestore.instance.collection('actividades').doc();
    Actividad actividad = Actividad(
        id: docActividad.id, nombre: nombre, descripcion: descripcion);

    final json = actividad.toJson();
    await docActividad.set(json).then((value) {
      const snackBar = SnackBar(
        content: Text('La actividad se ha registrado correctamente a FIREBASE'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
    Navigator.pop(context);
  }

  Widget buidlTextField(Icon icon, String hintText, bool isPwd, bool isEmail,
      int maxlines, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextField(
        obscureText: isPwd,
        controller: controller,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        maxLines: maxlines,
        decoration: InputDecoration(
          prefixIcon: icon,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Color(0XFFA7BCC7),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(15),
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

class _Encabezado extends StatelessWidget {
  const _Encabezado({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: MediaQuery.of(context).size.width,
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Theme.of(context).primaryColor),
      child: const Center(
        child: Text(
          'Actividades',
          style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
