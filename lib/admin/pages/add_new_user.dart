import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/admin/widgets/app_drawer.dart';

class AddNewUser extends StatefulWidget {
  const AddNewUser({Key? key}) : super(key: key);

  @override
  _AddNewUserState createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  bool isLoading = false;

  Map<String, String?> form = {"name": "", "password": "", "role": ""};

  var usersCollection = FirebaseFirestore.instance.collection('users');

  void changeLoadingState() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  Future<void> addUser() {
    changeLoadingState();
    return usersCollection.add(form).then((value) {
      changeLoadingState();
      print('success');
    }).catchError((e) {
      if (isLoading) changeLoadingState();
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text("مستخدم جديد"),
          ),
          drawer: AppDrawer(),
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 25),
            children: [
              SizedBox(height: 40),
              TextFormField(
                decoration: InputDecoration(hintText: 'الاسم'),
                onChanged: (value) {
                  form['name'] = value;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'كلمة السر',
                ),
                obscureText: true,
                onChanged: (value) {
                  form['password'] = value;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(hintText: 'رقم الهاتف'),
                onChanged: (value) {
                  form['phoneNumber'] = value;
                },
              ),
              SizedBox(height: 30),
              DropdownButtonFormField<String>(
                hint: Text("النوع"),
                onChanged: (value) {
                  form['role'] = value;
                },
                items: const [
                  DropdownMenuItem(
                    child: Text('مستخدم'),
                    value: 'user',
                  ),
                  DropdownMenuItem(
                    child: Text('عامل'),
                    value: 'worker',
                  ),
                  DropdownMenuItem(
                    child: Text('مدير'),
                    value: 'admin',
                  ),
                ],
              ),
              SizedBox(height: 80),
              _AddButton(onPressed: () => addUser(), showLoading: isLoading)
            ],
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({Key? key, this.showLoading = false, this.onPressed})
      : super(key: key);

  final bool showLoading;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: const Color(0xFF61A4F1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      child: const Text(
        'إضافة',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
