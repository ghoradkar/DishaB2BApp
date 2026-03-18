import 'package:flutter/material.dart';

class GeneratedInvoiceTextfield extends StatelessWidget {
  final TextEditingController controller;
  final double totalRemain;
  final Function onChanged;
  final bool readOnly;

  const GeneratedInvoiceTextfield({
    super.key,
    required this.controller,
    required this.totalRemain, required this.onChanged, required this.readOnly,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: TextInputType.number,
      onChanged: (value){
        onChanged(value);
      },
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "This field is required";
        }

        final entered = double.tryParse(value);
        if (entered == null) return "Invalid number";
        if (entered < 0) return "Cannot be less than 0";
        if (entered > totalRemain) return "Cannot exceed ₹$totalRemain";

        return null;
      },
      // style: const TextStyle(color: Colors.white),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.black,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        //floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixIcon: const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
          child: Icon(
            Icons.money,
            color: Colors.black,
          ),
        ),

        hintStyle: const TextStyle(fontSize: 14),
        label: RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Amount',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontFamily: 'Nunito Sans'),
              ),
            ],
          ),
        ),

        floatingLabelStyle: const TextStyle(
            color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}
