class Worker {
  String? id;

  String? phoneNumber;

  String? role;

  String? name;

  static Worker fromMap(Map<String, dynamic> map) {
    var worker = Worker();

    worker.id = map['id'];
    worker.phoneNumber = map['phoneNumber'];
    worker.role = map['role'];
    worker.name = map['name'];

    return worker;
  }
}
