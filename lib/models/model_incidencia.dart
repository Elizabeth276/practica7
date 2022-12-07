class Incidencia {
  String? id;
  String? tipo;
  String? date;
  String? name;
  String? time;

  Incidencia({
    this.id,
    required this.tipo,
    required this.date,
    required this.name,
    required this.time,
  });

  Map<String, dynamic> toJson() =>
      {'id': id, 'tipo': tipo, 'date': date, 'name': name, 'time': time};
}
