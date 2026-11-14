import 'dart:io';

import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

/// A family member's photo, or their first letter when there is none.
class ContactPhoto extends StatelessWidget {
  const ContactPhoto({
    required this.name,
    required this.path,
    required this.size,
    super.key,
  });

  final String name;
  final String? path;
  final double size;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(size / 7);
    final photo = path;
    if (photo != null) {
      final pixels = (size * MediaQuery.devicePixelRatioOf(context)).round();
      return ClipRRect(
        borderRadius: radius,
        child: Image.file(
          File(photo),
          width: size,
          height: size,
          fit: BoxFit.cover,
          cacheWidth: pixels,
          semanticLabel: context.l10n.photoOf(name),
          errorBuilder: (context, _, _) => _Initial(name: name, size: size),
        ),
      );
    }
    return ClipRRect(
      borderRadius: radius,
      child: _Initial(name: name, size: size),
    );
  }
}

class _Initial extends StatelessWidget {
  const _Initial({required this.name, required this.size});

  final String name;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final trimmed = name.trim();
    // Whole first grapheme, so Telugu and Hindi letters keep their vowel sign.
    final initial = trimmed.isEmpty
        ? '?'
        : trimmed.characters.first.toUpperCase();
    return Container(
      width: size,
      height: size,
      color: scheme.secondaryContainer,
      alignment: Alignment.center,
      child: Text(
        initial,
        style: TextStyle(
          fontSize: size * 0.45,
          fontWeight: FontWeight.w700,
          color: scheme.onSecondaryContainer,
        ),
        textScaler: TextScaler.noScaling,
      ),
    );
  }
}
