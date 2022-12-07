import 'package:flutter/material.dart';

class NewIncidenciaProvider with ChangeNotifier {
  String _tipoIncidencia = 'Falta';

  String getTipoIncidencia() => _tipoIncidencia;

  setTipoIncidencia(String tipoIncidencia) {
    this._tipoIncidencia = _tipoIncidencia;
    notifyListeners();
  }
}
