import 'package:flutter/material.dart';
import 'package:parking_graduation_app_1/core/models/accounts/user.dart';

class UserSelector extends StatefulWidget {
  final void Function(User) onUserSelect;
  const UserSelector({Key? key, required this.onUserSelect}) : super(key: key);

  @override
  _UserSelectorState createState() => _UserSelectorState();
}

class _UserSelectorState extends State<UserSelector> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
