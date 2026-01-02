import 'package:flutter/material.dart';

class AppGradients {
  static final List<LinearGradient> gradients = [
    const LinearGradient(
      colors: [Color(0xFF667eea), Color(0xFF764ba2)], // Purple → Pink
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF4facfe), Color(0xFF00f2fe)], // Blue → Cyan
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFFfa709a), Color(0xFFfee140)], // Pink → Yellow
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFF30cfd0), Color(0xFF330867)], // Cyan → Purple
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    const LinearGradient(
      colors: [Color(0xFFa8edea), Color(0xFFfed6e3)], // Mint → Pink
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ];
}
