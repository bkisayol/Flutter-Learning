import 'package:flutter/material.dart';

class AnimatedTextfield extends StatefulWidget {
  const AnimatedTextfield(
      {super.key,
      required this.label,
      required this.inputType,
      this.obsureText,
      required this.validation,
      required this.onSaved});

  final bool? obsureText;
  final String? Function(String?)? validation;
  final void Function(String?)? onSaved;
  final String label;
  final TextInputType inputType;
  @override
  State<AnimatedTextfield> createState() => _AnimatedTextfieldState();
}

class _AnimatedTextfieldState extends State<AnimatedTextfield> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validation,
      onSaved: widget.onSaved,
      obscureText: widget.obsureText ?? false,
      keyboardType: widget.inputType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        label: Text(
          widget.label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.blue,
            width: _animation.value * 4.0, // Animate the border width
          ),
        ),
      ),
      onTap: () {
        _controller.forward(); // Start the animation
      },
      onEditingComplete: () {
        _controller.reverse(); // Reverse the animation when editing is complete
      },
    );
  }
}
