import 'package:flutter/material.dart';

/// A raised plastic key with a darker lower edge, like the keys on an old
/// home phone. It sinks when pressed.
class PhoneKey extends StatefulWidget {
  const PhoneKey({
    required this.child,
    required this.color,
    required this.edgeColor,
    required this.semanticLabel,
    this.onTap,
    this.onLongPress,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(18)),
    ),
    this.depth = 6,
    super.key,
  });

  final Widget child;
  final Color color;
  final Color edgeColor;

  /// What a screen reader says; the child is not read separately.
  final String semanticLabel;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final ShapeBorder shape;

  /// How far the key stands up from the body, in logical pixels.
  final double depth;

  @override
  State<PhoneKey> createState() => _PhoneKeyState();
}

class _PhoneKeyState extends State<PhoneKey> {
  bool _pressed = false;

  void _setPressed(bool pressed) {
    if (_pressed != pressed) setState(() => _pressed = pressed);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null || widget.onLongPress != null;
    final sink = _pressed ? widget.depth - 1 : 0.0;
    return Semantics(
      container: true,
      button: true,
      enabled: enabled,
      label: widget.semanticLabel,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: enabled ? (_) => _setPressed(true) : null,
        onTapUp: enabled ? (_) => _setPressed(false) : null,
        onTapCancel: () => _setPressed(false),
        onTap: widget.onTap,
        onLongPress: widget.onLongPress == null
            ? null
            : () {
                _setPressed(false);
                widget.onLongPress!();
              },
        child: Padding(
          padding: EdgeInsets.only(bottom: widget.depth),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 70),
            transform: Matrix4.translationValues(0, sink, 0),
            decoration: ShapeDecoration(
              shape: widget.shape,
              color: widget.color,
              shadows: [
                BoxShadow(
                  color: widget.edgeColor,
                  offset: Offset(0, widget.depth - sink),
                ),
              ],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
