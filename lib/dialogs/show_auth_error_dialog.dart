import 'package:flutter/material.dart' show BuildContext;
import 'package:photo_gallery_app/auth/auth_error.dart';
import 'package:photo_gallery_app/dialogs/generic_dialog.dart';

Future<void> showAuthErrorDialog({
  required AuthError authError,
  required BuildContext context,
}) {
  return showGenericDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionsBuilder: () => {
      'OK': true,
    },
  );
}
