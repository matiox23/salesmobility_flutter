import 'package:flutter/material.dart';
import 'package:flutter_app_users/models/models.dart';

class DropDownWidget extends StatefulWidget {
  final String label;
  final List<ItemDropDown> list;
  const DropDownWidget({super.key, required this.list, required this.label});

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  String dropdownValue = '';

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      label: Text(widget.label),
      initialSelection: widget.list.first.value,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      dropdownMenuEntries:
          widget.list.map<DropdownMenuEntry<String>>((ItemDropDown item) {
        return DropdownMenuEntry<String>(value: item.value, label: item.label);
      }).toList(),
    );
  }
}
