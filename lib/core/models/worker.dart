class Worker {
  String? id;

  String? phoneNumber;

  String? name;

  String? userName;

  int? salary;

  static Worker fromMap(Map<String, dynamic> map) {
    var worker = Worker();

    worker.id = map['id'];
    worker.phoneNumber = map['phoneNumber'];
    worker.name = map['name'];
    worker.userName = map['userName'];
    worker.salary = map['salary'];
    return worker;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['id'] = id;
    map['phoneNumber'] = phoneNumber;
    map['name'] = 'name';
    map['userName'] = userName;
    map['salary'] = salary;

    return map;
  }
}
