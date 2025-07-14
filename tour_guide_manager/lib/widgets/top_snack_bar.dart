import 'package:flutter/material.dart';

void showTopSnackBar(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 20,
      right: 20,
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.info, color: Color(0xff005BFF)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                    color: Color(0xff333333)
                  )
                )
              )
            ],
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 3), () {
    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
  });
}