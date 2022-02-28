import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/core/Helpers/ui_helper.dart';
import 'package:parking_graduation_app_1/core/models/application_users/user.dart';
import 'package:parking_graduation_app_1/core/services/application_users_api_service.dart';
import 'package:parking_graduation_app_1/core/services/current_application_user_service.dart';
import 'package:parking_graduation_app_1/core/services/payments_api_service.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({Key? key}) : super(key: key);

  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  Map<String, dynamic> form = {};

  bool isExternalCustomer = false;
  var isLoading = false;
  List<User> users = [];

  var paymentsApiService = PaymentsApiService();
  var currentUserApplicationService = CurrentApplicationUserService();
  User? selectedUser;

  @override
  void initState() {
    super.initState();
    initializeForm();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text('دفعة جديدة'),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            children: [
              const SizedBox(height: 60),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'المبلغ',
                ),
                onChanged: (value) {
                  form['amount'] = double.parse(value);
                },
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  const Text('المستخدم:', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<User>(
                      onChanged: isExternalCustomer
                          ? null
                          : (user) {
                              selectedUser = user;
                              form['userFullName'] = user?.name;
                              form['userId'] = user?.id;
                            },
                      items: [
                        for (var user in users)
                          DropdownMenuItem(
                            child: Text(
                              '${user.name} - ${user.userName}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            value: user,
                          ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              CheckboxListTile(
                value: isExternalCustomer,
                title: Text('زبون خارجي'),
                onChanged: (value) {
                  setState(() {
                    isExternalCustomer = !isExternalCustomer;
                    if (isExternalCustomer) {
                      form['userFullName'] = 'زبون خارجي';
                      form['userId'] = null;
                    } else {
                      form['userFullName'] = selectedUser?.name;
                      form['userId'] = selectedUser?.id;
                    }
                  });
                },
              ),
              const SizedBox(height: 80),
              _AddButton(
                onPressed: () => addPayment(),
                showLoading: isLoading,
              )
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

  void initializeForm() async {
    form = {
      'amount': 0.0,
      'workerId': await currentUserApplicationService.getId(),
      'workerFullName': await currentUserApplicationService.getName(),
      'date': DateTime.now().toString().substring(0, 16)
    };
  }

  void getUsers() async {
    users = await ApplicationUsersApiService().getUsers();
    setState(() {});
  }

  void addPayment() async {
    changeLoadingState();
    paymentsApiService.addPayment(form);
    changeLoadingState();
    UiHelper.showDialogWithOkButton(
      context,
      'تمت الإضافة بنجاح',
      (_) => Navigator.of(context).pop(),
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
              ),
            )
          : const Text(
              'إضافة',
              style: TextStyle(fontSize: 18),
            ),
    );
  }
}
