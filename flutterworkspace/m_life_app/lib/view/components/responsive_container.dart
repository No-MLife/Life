import 'package:flutter/material.dart';

class ResponsiveContainer extends StatelessWidget {
  final Widget child;

  const ResponsiveContainer({required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double maxWidth = constraints.maxWidth * 0.9; // 최대 너비를 90%로 설정
        return Container(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
          ),
          padding: EdgeInsets.symmetric(horizontal: constraints.maxWidth * 0.05), // 양쪽 5% 패딩
          child: child,
        );
      },
    );
  }
}