import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HoverText extends StatefulWidget {
  HoverText(
      {Key? key,
      required this.child,
      required this.hoverChild,
      required this.onHover})
      : super(key: key);

  final Widget child;
  final Widget hoverChild;
  final Function(PointerEnterEvent event) onHover;
  @override
  _HoverTextState createState() => _HoverTextState();
}

class _HoverTextState extends State<HoverText> {
  
  bool _isHover = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _isHover = true;
        });
        widget.onHover(event);
      },
      onExit: (event) {
        setState(() {
          _isHover = false;
        });
      },
      child: _isHover ? widget.hoverChild : widget.child,
    );
  }
}
