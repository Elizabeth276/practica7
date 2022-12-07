class Actividad {
  String? id;
  String? nombre;
  String? descripcion;

  Actividad({
    this.id,
    required this.nombre,
    required this.descripcion,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'descripcion': descripcion,
      };
}
