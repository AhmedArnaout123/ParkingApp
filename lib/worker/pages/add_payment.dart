import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/core/Helpers/ui_helper.dart';
import 'package:parking_graduation_app_1/core/Providers/current_worker_provider.dart';
import 'package:parking_graduation_app_1/core/models/accounts/user.dart';
import 'package:parking_graduation_app_1/core/services/Api/payments_api_service.dart';
import 'package:parking_graduation_app_1/core/services/Api/users_api_service.dart';

class AddPayment extends StatefulWidget {
  const AddPayment({Key? key}) : super(key: key);

  @override
  _AddPaymentState createState() => _AddPaymentState();
}

class _AddPaymentState extends State<AddPayment> {
  Map<String, dynamic> form = {};

  bool isExternalCustomer = false;
  var isLoading = false;

  User? selectedUser;

  @override
  void initState() {
    super.initState();
    initializeForm();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('دفعة جديدة'),
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
                  form['amount'] = int.parse(value);
                },
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  const Text('المستخدم:', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FutureBuilder<List<User>>(
                      future: UsersApiService().getUsersFuture(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return Container();
                        var users = snapshot.data!;
                        selectedUser = users[0];
                        return DropdownButtonFormField<User>(
                          value: selectedUser,
                          onChanged: isExternalCustomer
                              ? null
                              : (user) {
                                  selectedUser = user;
                                },
                          items: users
                              .map(
                                (user) => DropdownMenuItem(
                                  child: Text(
                                    '${user.fullName} - ${user.userName}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  value: user,
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              CheckboxListTile(
                value: isExternalCustomer,
                title: const Text('زبون خارجي'),
                onChanged: (value) {
                  setState(() {
                    isExternalCustomer = !isExternalCustomer;
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

  void initializeForm() {
    var worker = CurrentWorkerProvider().worker;
    form = {
      'amount': 0,
      'workerId': worker.id,
      'workerFullName': worker.fullName,
      'date': DateTime.now().toString().substring(0, 16)
    };
  }

  void addPayment() async {
    changeLoadingState();

    form['userId'] = isExternalCustomer ? null : selectedUser!.id;
    form['userFullName'] =
        isExternalCustomer ? 'زبون خارجي' : selectedUser!.fullName;
    PaymentsApiService().addPayment(form);

    if (!isExternalCustomer) {
      await UsersApiService().addToBalance(form['userId'], form['amount']);
    }

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
