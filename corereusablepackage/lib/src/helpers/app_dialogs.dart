import 'package:flutter/material.dart';
import '../widgets/app_confirm_dialog.dart';
import '../widgets/app_bottom_sheet.dart';
import '../theme/app_colors.dart';

class AppDialogs {
  AppDialogs._();

  static Future<bool> showConfirm({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    Color? confirmColor,
  }) {
    return AppConfirmDialog.show(
      context: context,
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      confirmColor: confirmColor,
    );
  }

  static Future<bool> showDelete({
    required BuildContext context,
    required String itemName,
    String title = 'Delete',
    String confirmLabel = 'Delete',
    String cancelLabel = 'Cancel',
  }) {
    return showConfirm(
      context: context,
      title: title,
      message: 'Are you sure you want to delete $itemName?',
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      confirmColor: AppColors.red,
    );
  }

  static Future<T?> showSheet<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    bool isScrollControlled = true,
  }) {
    return AppBottomSheet.show<T>(
      context: context,
      title: title,
      child: child,
      isScrollControlled: isScrollControlled,
    );
  }

  static void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  static void hideLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
