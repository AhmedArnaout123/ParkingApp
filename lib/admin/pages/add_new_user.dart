import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/admin/widgets/admin_drawer.dart';
import 'package:parking_graduation_app_1/core/Helpers/ui_helper.dart';

class AddNewUser extends StatefulWidget {
  const AddNewUser({Key? key}) : super(key: key);

  @override
  _AddNewUserState createState() => _AddNewUserState();
}

class _AddNewUserState extends State<AddNewUser> {
  bool isLoading = false;

  Map<String, String?> form = {
    "name": "",
    "password": "",
    "phoneNumber": "",
  };

  var usersCollection = FirebaseFirestore.instance.collection('users');

  void changeLoadingState() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  Future<void> addUser() {
    changeLoadingState();
    return usersCollection.add(form).then((value) {
      UiHelper.showDialogWithOkButton(context, 'تمت الإضافة بنجاح');
      changeLoadingState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("مستخدم جديد"),
          ),
          drawer: const AdminDrawer(),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            children: [
              const SizedBox(height: 40),
              TextFormField(
                decoration: const InputDecoration(hintText: 'الاسم'),
                onChanged: (value) {
                  form['name'] = value;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'كلمة السر',
                ),
                obscureText: true,
                onChanged: (value) {
                  form['password'] = value;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(hintText: 'رقم الهاتف'),
                onChanged: (value) {
                  form['phoneNumber'] = value;
                },
              ),
              const SizedBox(height: 30),
              DropdownButtonFormField<String>(
                hint: const Text("النوع"),
                onChanged: (value) {
                  form['role'] = value;
                },
                items: const [
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
              const SizedBox(height: 80),
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
  final VoidCallback? onPressed;
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
      child: showLoading
          ? const Center(
              child: SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ))
          : const Text(
              'إضافة',
              style: TextStyle(fontSize: 18),
            ),
    );
  }
}
