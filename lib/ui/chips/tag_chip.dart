import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    // seed color for the chip

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        border: Border.fromBorderSide(BorderSide(color: Colors.red)),
        borderRadius: BorderRadius.all(Radius.circular(64)),
        color: Color.fromARGB(69, 244, 67, 54),
      ),
      child: Row(
        spacing: 4,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadiusGeometry.circular(64),
      // ),
    );
  }
}
