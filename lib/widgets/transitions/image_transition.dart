import 'dart:async';

import 'package:flutter/material.dart';

class ImageTransition extends StatefulWidget {
  ImageTransition({Key? key}) : super(key: key);

  @override
  _ImageTransitionState createState() => _ImageTransitionState();
}

class _ImageTransitionState extends State<ImageTransition> {
  late Timer _timer;
  int _start = 4;
  late Image image;

  @override
  void initState() {
    super.initState();
    image = Image.asset(
      'assets/images/poppetje3.png',
      scale: 2,
    );

    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(milliseconds: 1000);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
          } else {
            //every second change image;
            _start = _start - 1;

            switch (_start) {
              case 3:
                image = Image.asset(
                  'assets/images/poppetje2.png',
                  scale: 2,
                );
                return;

              case 2:
                image = Image.asset(
                  'assets/images/poppetje1.png',
                  scale: 2,
                );
                return;

              case 1:
                image = Image.asset(
                  'assets/images/poppetje1.png',
                  scale: 2,
                );
                return;
              default:
                return;
            }
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Container(
        constraints: BoxConstraints(
          minHeight: size.height / 2,
          maxHeight: size.height / 2,
          maxWidth: size.width / 3,
          minWidth: size.width / 3,
        ),
        key: UniqueKey(),
        child: image,
      ),
    );
  }
}
