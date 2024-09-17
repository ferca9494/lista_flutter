import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class addcart_animscreen extends StatefulWidget {
  const addcart_animscreen({required this.item, required this.onFinish});

  final Widget item;
  final Function() onFinish;

  @override
  State<addcart_animscreen> createState() => _addcart_animscreenState();
}

class _addcart_animscreenState extends State<addcart_animscreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Center(
              child: Stack(alignment: AlignmentDirectional(0, -1), children: [
            Dance(
                //     from: 200,
                curve: Curves.bounceInOut,
                onFinish: (a) {
                  Navigator.pop(context);
                  widget.onFinish();
                },
                child: widget.item

                /*
                CircleAvatar(
                  backgroundColor: Colors.orange,
                )
                */
                ),
            const Icon(
              Icons.shopping_cart_rounded,
              size: 90,
              color: Colors.black,
            )
          ])),
        ));
  }
}
