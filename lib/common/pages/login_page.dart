import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:parking_graduation_app_1/admin/pages/locations/view_locations.dart';
import 'package:parking_graduation_app_1/core/Providers/current_user_provider.dart';
import 'package:parking_graduation_app_1/core/Providers/current_worker_provider.dart';
import 'package:parking_graduation_app_1/core/services/Api/accounts_api_service.dart';
import 'package:parking_graduation_app_1/core/services/storage_service.dart';
import 'package:parking_graduation_app_1/users/pages/home_page.dart';
import 'package:parking_graduation_app_1/worker/pages/view_worker_locations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoginMode = true;
  bool isLoading = false;

  Map<String, dynamic> form = {};

  final kHintTextStyle = const TextStyle(
    color: Colors.white54,
    fontFamily: 'OpenSans',
  );

  final kLabelStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
  );

  final kBoxDecorationStyle = BoxDecoration(
    color: const Color(0xFF6CA8F1),
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: const [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  Widget _buildTextField(String label, String hintText, onChanged,
      [bool hideText = false]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: kLabelStyle,
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            onChanged: onChanged,
            obscureText: hideText,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: 14.0),
              prefixIcon: const Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: hintText,
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          padding: const EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          primary: Colors.white,
        ),
        onPressed: submit,
        child: !isLoading
            ? Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF527DAA),
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              )
            : const Center(
                child: SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                ),
              ),
              SizedBox(
                height: double.infinity,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: isLoginMode ? 120.0 : 60.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'أهلاً بك',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () => setState(() => isLoginMode = !isLoginMode),
                        child: Text(
                          isLoginMode ? 'إنشاء حساب جديد' : 'تسجيل الدخول',
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'OpenSans',
                            fontSize: 16.0,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      if (!isLoginMode)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 30.0,
                            ),
                            _buildTextField('الاسم الكامل', 'أدخل اسمك الكامل',
                                (value) {
                              form['fullName'] = value;
                            })
                          ],
                        ),
                      if (!isLoginMode)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              height: 30.0,
                            ),
                            _buildTextField('رقم الهاتف', 'أدخل رقم الهاتف',
                                (value) {
                              form['phoneNumber'] = value;
                            })
                          ],
                        ),
                      const SizedBox(height: 30.0),
                      _buildTextField(
                        "اسم المستخدم",
                        "أدخل اسم المستخدم",
                        (value) => form["userName"] = value,
                      ),
                      const SizedBox(height: 30.0),
                      _buildTextField(
                        "كلمة المرور",
                        "أدخل كلمة المرور",
                        (value) => form['password'] = value,
                        true,
                      ),
                      const SizedBox(height: 20),
                      _buildLoginBtn(
                          isLoginMode ? 'تسجيل الدخول' : 'إنشاء الحساب'),
                    ],
                  ),
                ),
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

  void submit() async {
    changeLoadingState();
    if (isLoginMode) {
      var account =
          await AccountsApiService().login(form['userName'], form['password']);
      await StorageService().write('userId', account.id);

      if (account.role == 'user') {
        await CurrentUserProvider.initialize(account.id!);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const UserHomePage(),
          ),
        );

        await StorageService().write('userRole', 'user');
      } else if (account.role == 'worker') {
        await CurrentWorkerProvider.initialize(account.id!);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ViewWorkerLocations(),
          ),
        );

        await StorageService().write('userRole', 'worker');
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ViewAdminLocations(),
          ),
        );

        await StorageService().write('userRole', 'admin');
      }
    } else {
      var id = await AccountsApiService().registerUser(form['fullName'],
          form['userName'], form['phoneNumber'], form['password']);

      await CurrentUserProvider.initialize(id);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const UserHomePage(),
        ),
      );
    }
    changeLoadingState();
  }
}
