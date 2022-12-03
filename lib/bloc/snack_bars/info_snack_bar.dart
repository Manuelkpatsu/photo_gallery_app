import 'package:flutter/material.dart';

void showInfoSnackBar({
  required BuildContext context,
  required String title,
  required String description,
}) {
  final snackBar = SnackBar(
    content: IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(description)
        ],
      ),
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
