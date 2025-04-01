import 'package:flutter/material.dart';

class LoadingTween extends StatefulWidget {
  const LoadingTween({
    super.key,
    this.height = 150,
    this.width = 150,
    this.borderRadius = 5,
  });

  final double? height;
  final double? width;
  final double borderRadius;

  @override
  // ignore: library_private_types_in_public_api
  _LoadingTween createState() => _LoadingTween();
}

class _LoadingTween extends State<LoadingTween>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }

  Animatable<Color?> background = TweenSequence<Color?>([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.black.withAlpha(20),
        end: Colors.black.withAlpha(50),
      ),
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.black.withAlpha(50),
        end: Colors.black.withAlpha(20),
      ),
    ),
  ]);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.all(5),
          alignment: Alignment.topLeft,
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: background.evaluate(
              AlwaysStoppedAnimation(_controller.value),
            ),
          ),
        );
      },
    );
  }
}
