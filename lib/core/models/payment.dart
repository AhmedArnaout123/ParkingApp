class Payment {
  String? id;

  String? userId;

  String? userFullName;

  String? workerId;

  String? workerFullName;

  String? date;

  double? amount;

  static Payment fromMap(Map<String, dynamic> map) {
    var payment = Payment();

    payment.id = map['id'];
    payment.userId = map['userId'];
    payment.date = map['date'];
    payment.userFullName = map['userFullName'];
    payment.workerId = map['workerId'];
    payment.workerFullName = map['workerFullName'];
    payment.amount = map['amount'] + 0.0;
    return payment;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'date': date,
      'userFullName': userFullName,
      'workerId': workerId,
      'workerFullName': workerFullName,
      'amount': amount,
    };
  }
}
