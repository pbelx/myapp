import 'package:flutter/material.dart';

class DopeBox extends StatelessWidget {
  final Widget? child;
  const DopeBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            //dark shadow bottom right
            BoxShadow(
                color: Colors.grey.shade500,
                blurRadius: 8,
                offset: const Offset(4, 4)),
            BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 5,
                offset: const Offset(-4, -4))

            //light shadow top left
          ]),
          padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}
