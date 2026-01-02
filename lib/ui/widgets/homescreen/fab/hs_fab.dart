import 'package:flutter/material.dart';
import 'package:flutter_arch/data/locator/locator.dart';
import 'package:flutter_arch/ui/widgets/homescreen/body/service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HSFloatingActionButton extends StatelessWidget {
  const HSFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF667eea), Color(0xFF764ba2)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF667eea).withAlpha(128),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () =>
                locator<HSService>().showAddEditDialog(context, ref),
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.add, size: 32),
          ),
        );
      },
    );
  }
}
