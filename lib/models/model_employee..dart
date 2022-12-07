class Employee {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? date;
  String? photo;

  Employee(
      {this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.date,
      required this.photo});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'date': date,
        'photo': photo
      };
}
