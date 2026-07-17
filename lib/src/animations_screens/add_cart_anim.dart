import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class addcart_animscreen extends StatefulWidget {
  const addcart_animscreen({super.key, required this.item, required this.onFinish});

  final Widget item;
  final Function() onFinish;

  @override
  State<addcart_animscreen> createState() => _addcart_animscreenState();
}

class _addcart_animscreenState extends State<addcart_animscreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fallAnimation;
  late final Animation<double> _shrinkAnimation;
  late final Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fallAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeIn),
      ),
    );

    _shrinkAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 0.85, curve: Curves.easeIn),
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.55, 0.85, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        SystemSound.play(SystemSoundType.click);
        widget.onFinish();
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cartIconSize = 90.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final fallProgress = _fallAnimation.value;
          final shrinkProgress = _shrinkAnimation.value;
          final rotateProgress = _rotateAnimation.value;

          final startY = -screenHeight * 0.35;
          final endY = 30.0;
          final currentY = startY + (endY - startY) * fallProgress;

          final scale = shrinkProgress;

          return Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: screenHeight / 2 - cartIconSize / 2 + 40,
                child: Center(
                  child: Icon(
                    Icons.shopping_cart_rounded,
                    size: cartIconSize,
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: screenHeight / 2 + currentY,
                child: Center(
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..scale(scale)
                      ..rotateZ(rotateProgress),
                    child: Opacity(
                      opacity: scale.clamp(0.0, 1.0),
                      child: widget.item,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
