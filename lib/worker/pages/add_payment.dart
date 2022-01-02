import 'package:flutter/material.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({Key? key}) : super(key: key);

  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  Map<String, dynamic> form = {
    'amount': 0.0,
    'workerId': 'fdsl',
    'workerFullName': 'dfslf',
    'userId': 'sldfj',
    'userFullName': 'fldsj',
    'date': DateTime.now().toString()
  };
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: Text('دفعة جديدة'),),
          body: ListView(children: [
            
          ],),
        ),
      ),
    );
  }
}
