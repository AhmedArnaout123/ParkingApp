import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/admin/widgets/admin_drawer.dart';
import 'package:parking_graduation_app_1/core/Helpers/ui_helper.dart';
import 'package:parking_graduation_app_1/core/services/Api/accounts_api_service.dart';

class AddWorkerOrAdmin extends StatefulWidget {
  const AddWorkerOrAdmin({Key? key}) : super(key: key);

  @override
  _AddWorkerOrAdminState createState() => _AddWorkerOrAdminState();
}

class _AddWorkerOrAdminState extends State<AddWorkerOrAdmin> {
  bool isLoading = false;

  Map<String, String?> form = {
    "userName": "",
    "fullName": "",
    "password": "",
    "phoneNumber": "",
    "role": ""
  };

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
                decoration: const InputDecoration(hintText: 'اسم المستخدم'),
                onChanged: (value) {
                  form['userName'] = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: 'الاسم الكامل'),
                onChanged: (value) {
                  form['fullName'] = value;
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

  void changeLoadingState() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void addUser() async {
    changeLoadingState();
    await AccountsApiService().addAccount(form);

    UiHelper.showDialogWithOkButton(context, 'تمت الإضافة بنجاح');
    changeLoadingState();
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
              ),
            )
          : const Text(
              'إضافة',
              style: TextStyle(fontSize: 18),
            ),
    );
  }
}
