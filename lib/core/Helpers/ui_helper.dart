import 'package:flutter/material.dart';

class UiHelper {
  static showDialogWithOkButton(BuildContext context, String message,
      [Function(dynamic)? popCallBack]) async {
    await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('حسناً'),
              )
            ],
          );
        }).then(
      (value) => {if (popCallBack != null) popCallBack(value)},
    );
  }

  static Future<bool> showDeleteConfirmationDialog(BuildContext context,
      [itemName]) async {
    var result = await showConfirmationDialog(
      context,
      'هل أنت متأكد من حذف ${itemName ?? 'العنصر'} ؟',
    );

    return result;
  }

  static Future<bool> showConfirmationDialog(
      BuildContext context, String message) async {
    var result = await showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (innerContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('نعم'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('لا'),
              ),
            ],
          ),
        );
      },
    );

    return result ?? false;
  }
}
