import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:practica7/models/model_employee..dart';
import 'package:practica7/providers/new_employee_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class NewEmpleadoScreen extends StatelessWidget {
  const NewEmpleadoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewEmployeeProvider(),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: const Text('Registra un nuevo empleado'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: _NewEmpleado(),
      ),
    );
  }
}

class _NewEmpleado extends StatefulWidget {
  _NewEmpleado({
    Key? key,
  }) : super(key: key);

  @override
  State<_NewEmpleado> createState() => _NewEmpleadoState();
}

class _NewEmpleadoState extends State<_NewEmpleado> {
  final picker = ImagePicker();

  String? path = '';
  String? fileName = '';

  TextEditingController txtNombre = TextEditingController();

  TextEditingController txtMail = TextEditingController();

  TextEditingController txtPhone = TextEditingController();

  TextEditingController txtFecha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewEmployeeProvider>(context);

    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const _Encabezado(),
            const SizedBox(height: 10),
            _buildForm(context, provider),
            const SizedBox(height: 10),
            _buildButtonRegistro(context, provider),
            _buildButtonCancelar(context),
          ],
        ),
      ),
    );
  }

  Future setImagen(provider) async {
    var pickedFile;
    pickedFile = await picker.pickImage(source: ImageSource.camera);
    path = pickedFile.path;
    provider.setPathImage(path);
  }

  Future createEmployee(String name, String email, String phone,
      String hireDate, String photo, context) async {
    final docEmployee =
        FirebaseFirestore.instance.collection('employees').doc();

    uploadImage(photo, docEmployee.id);

    Employee employee = Employee(
      id: docEmployee.id,
      name: name,
      email: email,
      phone: phone,
      date: hireDate,
      photo: photo,
    );

    final json = employee.toJson();

    await docEmployee.set(json).then((value) {
      const snackBar = SnackBar(
        content: Text('El empleado se agrego correctamente a FIREBASE'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
    Navigator.pop(context);
  }

  Future uploadImage(path, String idUser) async {
    File file = File(path);
    FirebaseStorage storage = FirebaseStorage.instance;
    UploadTask? uploadTask;
    final pathCloud = 'users/$idUser/${path}';
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('${urlDownload}');
  }

  Container _buildButtonCancelar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
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

  Container _buildButtonRegistro(BuildContext context, provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        height: 40.0,
        onPressed: () {
          createEmployee(
            txtNombre.text,
            txtMail.text,
            txtPhone.text,
            txtFecha.text,
            provider.getPathImage(),
            context,
          );
        },
        color: Theme.of(context).primaryColor,
        child: const Text('Registrar empleado',
            style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Container _buildForm(BuildContext context, provider) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      height: MediaQuery.of(context).size.height * 0.6,
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
            Container(
              height: 129,
              child: CircleAvatar(
                minRadius: 60,
                maxRadius: 60,
                backgroundImage: provider.getPathImage() == ''
                    ? const AssetImage('assets/img/user.png')
                    : FileImage(File(provider.getPathImage())) as ImageProvider,
              ),
            ),
            const SizedBox(height: 10),
            buidlTextField(const Icon(Icons.people), 'Nombre del empleado',
                false, false, txtNombre),
            const SizedBox(height: 10),
            buidlTextField(
                const Icon(Icons.email), 'Correo', false, true, txtMail),
            const SizedBox(height: 10),
            buidlTextField(
                const Icon(Icons.phone), 'Telefono', false, false, txtPhone),
            const SizedBox(height: 10),
            buidlTextField(const Icon(Icons.calendar_month), 'Fecha de ingreso',
                false, false, txtFecha),
            const SizedBox(height: 10),
            MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              height: 40.0,
              onPressed: () {
                setImagen(provider);
              },
              color: Theme.of(context).primaryColor,
              child: Text(
                'Subir fotografía',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
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
          'Empleado',
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
