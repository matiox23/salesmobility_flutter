import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String label;
  final String placeholder;
  final IconData iconData;

  const TextFieldWidget({
    super.key,
    required this.label,
    required this.placeholder,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label),
        const SizedBox(
          height: 5.0,
        ),
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey)),
          child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: placeholder,
                suffixIcon: Icon(
                  iconData,
                  color: Colors.grey,
                )),
          ),
        )
      ],
    );
  }
}
