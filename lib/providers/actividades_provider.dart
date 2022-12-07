import 'package:flutter/material.dart';

class NotificacionesProvider with ChangeNotifier {
  bool _notificaciones = false;

  bool getNotificaciones() => _notificaciones;

  setNotificacion(bool notificaciones) {
    this._notificaciones = notificaciones;
    notifyListeners();
  }
}
