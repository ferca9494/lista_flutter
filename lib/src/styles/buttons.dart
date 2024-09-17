import 'package:flutter/material.dart';

ButtonStyle btn({Color color = Colors.blue, bool selected = false}) =>
    ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
      ),
      backgroundColor: MaterialStateProperty.all<Color>(color),
      side: selected
          ? MaterialStateProperty.all<BorderSide>(
              BorderSide(color: Colors.black, width: 2),
            )
          : null,
    );
