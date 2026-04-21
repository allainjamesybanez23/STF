import 'package:flutter/material.dart';

class PeripheralGlowContainer extends StatefulWidget {
  const PeripheralGlowContainer({
    super.key,
    required this.child,
    required this.glowColor,
    this.pulse = false,
  });

  final Widget child;
  final Color glowColor;
  final bool pulse;

  @override
  State<PeripheralGlowContainer> createState() => _PeripheralGlowContainerState();
}

class _PeripheralGlowContainerState extends State<PeripheralGlowContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 920),
  );

  @override
  void initState() {
    super.initState();
    if (widget.pulse) {
      _controller.repeat(reverse: true);
    } else {
      _controller.value = 0.5;
    }
  }

  @override
  void didUpdateWidget(covariant PeripheralGlowContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pulse && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.pulse && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0.5;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final opacity = widget.pulse ? (0.3 + (_controller.value * 0.7)) : 0.45;
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.glowColor.withAlpha((opacity * 255).round()),
                blurRadius: 42,
                spreadRadius: 16,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}
