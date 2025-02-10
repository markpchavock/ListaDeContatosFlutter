import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TextFormFieldCustom extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color iconColor;
  final List<TextInputFormatter>? inputFormatter;
  final TextEditingController controller;
  final TextInputType? tipoInput;

  const TextFormFieldCustom({
    super.key,
    required this.label,
    required this.icon,
    required this.iconColor,
    this.inputFormatter,
    required this.controller,
    this.tipoInput,
  });

  @override
  State<TextFormFieldCustom> createState() => _TextFormFieldCustomState();
}

class _TextFormFieldCustomState extends State<TextFormFieldCustom> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: FaIcon(
              widget.icon,
              color: widget.iconColor,
              size: 20,
            )),
        SizedBox(width: 7),
        Expanded(
          child: TextFormField(
            controller: widget.controller,
            decoration: InputDecoration(
              label: Text(widget.label),
              labelStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
            inputFormatters: widget.inputFormatter,
            keyboardType: widget.tipoInput ?? TextInputType.text,
          ),
        ),
      ],
    );
  }
}
