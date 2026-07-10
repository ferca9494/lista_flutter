import 'package:flutter/material.dart';

ButtonStyle btn({Color color = Colors.blue, bool selected = false}) =>
    ButtonStyle(
      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      backgroundColor: WidgetStateProperty.all<Color>(color),
      side: selected
          ? WidgetStateProperty.all<BorderSide>(
              const BorderSide(color: Colors.black, width: 2),
            )
          : null,
    );
