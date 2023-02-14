import 'package:flutter/material.dart';

class Neomorphism extends StatelessWidget {
  final EdgeInsetsGeometry? padding, margin;
  final Widget child;
  const Neomorphism({
    this.padding,
    this.margin,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: const Color(0xffe0e5ec),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0xffffffff),
            blurRadius: 10,
            offset: Offset(-6, -6),
          ),
          BoxShadow(
            color: Color(0xffa3b1c6),
            blurRadius: 10,
            offset: Offset(6, 6),
          )
        ],
      ),
      child: child,
    );
  }
}
