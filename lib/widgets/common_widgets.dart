import 'package:flutter/material.dart';

Widget buildHeaderCard(BuildContext context, {
  required IconData icon,
  required String title,
  required String subtitle,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFCC3333).withOpacity(0.08),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFCC3333).withOpacity(0.2)),
    ),
    child: Row(children: [
      Container(
        width: 48, height: 48,
        decoration: BoxDecoration(color: const Color(0xFFCC3333), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: Colors.white, size: 26),
      ),
      const SizedBox(width: 14),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 3),
        Text(subtitle, style: TextStyle(fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6))),
      ])),
    ]),
  );
}

Widget buildFieldLabel(BuildContext context, String text) {
  return Text(text, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.onSurface));
}

Widget buildTextField({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  required BuildContext context,
  int maxLines = 1,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    maxLines: maxLines,
    validator: validator,
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4)),
      prefixIcon: maxLines == 1
          ? Icon(icon, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), size: 20)
          : null,
      filled: true,
      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 0.8),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFCC3333), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
  );
}