import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:practica7/models/model_incidencia.dart';
import 'package:practica7/providers/new_incidencia_provider.dart';
import 'package:provider/provider.dart';

class NewIncidenciaScreen extends StatelessWidget {
  const NewIncidenciaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewIncidenciaProvider(),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: const Text('Registra una nueva incidencia'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: _NewIncidencia(),
      ),
    );
  }
}

class _NewIncidencia extends StatefulWidget {
  _NewIncidencia({
    Key? key,
  }) : super(key: key);

  @override
  State<_NewIncidencia> createState() => _NewIncidenciaState();
}

class _NewIncidenciaState extends State<_NewIncidencia> {
  TextEditingController txtTipoIncidencia = TextEditingController();
  TextEditingController txtFechaIncidencia = TextEditingController();
  TextEditingController txtNombreEmpleado = TextEditingController();
  TextEditingController txtTimeIncidencia = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NewIncidenciaProvider>(context);
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
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

  Future createIncidencia(
      String tipo, String date, String name, String time, context) async {
    final docIncidencia =
        FirebaseFirestore.instance.collection('incidencias').doc();

    Incidencia incidencia = Incidencia(
      id: docIncidencia.id,
      tipo: tipo,
      date: date,
      name: name,
      time: time,
    );

    final json = incidencia.toJson();

    await docIncidencia.set(json).then((value) {
      const snackBar = SnackBar(
        content:
            Text('La incidencia se ha registrado correctamente a FIREBASE'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
    Navigator.pop(context);
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
          createIncidencia(txtTipoIncidencia.text, txtFechaIncidencia.text,
              txtNombreEmpleado.text, txtTimeIncidencia.text, context);
        },
        color: Theme.of(context).primaryColor,
        child: const Text('Registrar incidencia',
            style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Container _buildForm(BuildContext context, provider) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      height: MediaQuery.of(context).size.height * 0.36,
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
            buidlTextField(const Icon(Icons.type_specimen),
                'Tipo de incidencia', false, false, txtTipoIncidencia),
            const SizedBox(height: 10),
            buidlTextField(const Icon(Icons.calendar_month),
                'Fecha de incidencia', false, false, txtFechaIncidencia),
            const SizedBox(height: 10),
            buidlTextField(const Icon(Icons.people), 'Nombre del empleado',
                false, false, txtNombreEmpleado),
            const SizedBox(height: 10),
            buidlTextField(
                const Icon(Icons.punch_clock),
                'Tiempo acumulado en incidencias',
                false,
                false,
                txtTimeIncidencia),
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
          'Incidencias',
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
