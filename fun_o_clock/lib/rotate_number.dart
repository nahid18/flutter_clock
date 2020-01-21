import 'package:fun_o_clock/get_svg.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class RotateNumber extends StatefulWidget {
  final String rotateNumber;
  final double transitionHeight;
  final double svgWidth;

  const RotateNumber({
    Key key,
    @required this.rotateNumber,
    @required this.transitionHeight,
    @required this.svgWidth,
  }) : super(key: key);

  @override
  _RotateNumberState createState() => _RotateNumberState();
}

class _RotateNumberState extends State<RotateNumber>
    with TickerProviderStateMixin {
  String get _text => widget.rotateNumber;
  double get _transitionHeight => widget.transitionHeight;
  double get _svgWidth => widget.svgWidth;

  Timer _timer;
  DateTime _dateTime = DateTime.now();
  Duration _duration = Duration(milliseconds: 900);
  AnimationController _controller;
  Animation _fadeIn, _slideIn;

  @override
  void initState() {
    super.initState();
    _nextAnimation();
  }

  @override
  void dispose() {
    _controller
      ..stop()
      ..dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _transitionHeight,
      child: !_controller.isAnimating
          ? GetSVG(
              width: _svgWidth,
              number: int.parse(_text),
            )
          : AnimatedBuilder(
              animation: _controller,
              builder: (BuildContext context, Widget child) {
                return AlignTransition(
                  alignment: _slideIn,
                  child: Opacity(
                    opacity: _fadeIn.value,
                    child: GetSVG(
                      width: _svgWidth,
                      number: int.parse(_text),
                    ),
                  ),
                );
              },
            ),
    );
  }
  

  void _nextAnimation() {
    if (_controller != null) _controller.dispose();

    setState(() {
      _dateTime = DateTime.now();
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _nextAnimation,
      );
    });

    _controller = new AnimationController(
      duration: _duration,
      vsync: this,
    );

    // Slide in Animation
    _slideIn = AlignmentTween(
      begin: Alignment(-1.0, -1.0),
      end: Alignment(-1.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.4, curve: Curves.easeInCubic),
      ),
    );

    // Fade in Animation
    _fadeIn = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0.0, 0.4, curve: Curves.easeOutCubic),
      ),
    );

    _controller.forward();
  }
}
