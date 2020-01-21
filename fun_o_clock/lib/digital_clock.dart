// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:fun_o_clock/get_svg.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'rotate_number.dart';

enum _Element {
  background,
  // text,
  // shadow,
}

final _lightTheme = {
  _Element.background: Colors.white,
  // _Element.text: Colors.pink,
  // _Element.shadow: Colors.pink[900],
};

final _darkTheme = {
  _Element.background: Color(0xFF2F2D52),
  // _Element.text: Colors.white,
  // _Element.shadow: Colors.pink,
};

class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);
  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  Map store = Map();

  bool isHour0Same = true, isHour1Same = true, isMinute0Same = true;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {});
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      var _hour = DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh')
          .format(_dateTime);
      var _minute = DateFormat('mm').format(_dateTime);
      // var _second = DateFormat('ss').format(_dateTime);

      if (store.isNotEmpty) {
        // Check old value with the new value and then replace with it
        if (store['hour_0'] != _hour[0]) {
          isHour0Same = false;
          store['hour_0'] = _hour[0];
        } else {
          isHour0Same = true;
        }
        if (store['hour_1'] != _hour[1]) {
          isHour1Same = false;
          store['hour_1'] = _hour[1];
        } else {
          isHour1Same = true;
        }

        // Same Process (explained above) for Minutes
        if (store['minute_0'] != _minute[0]) {
          isMinute0Same = false;
          store['minute_0'] = _minute[0];
        } else {
          isMinute0Same = true;
        }
        store['minute_1'] = _minute[1];
      } else {
        store['hour_0'] = _hour[0];
        store['hour_1'] = _hour[1];
        store['minute_0'] = _minute[0];
        store['minute_1'] = _minute[1];
      }

      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;

    // Time
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    // final second = DateFormat('ss').format(_dateTime);

    // Date
    final month = DateFormat('MM').format(_dateTime);
    final day = DateFormat('dd').format(_dateTime);
    final year = DateFormat('yyyy').format(_dateTime);

    // Responsive Widths for SVGs, Colon and Containers
    final mediaWidth = MediaQuery.of(context).size.width;
    final mediaHeight = MediaQuery.of(context).size.height;
    final svgWidth = mediaWidth * 0.1;
    final colonWidth = svgWidth * 0.9;

    // Responsive Sizes for FontSize and Transition Height
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final fontSize = isPortrait ? mediaWidth / 6 : mediaWidth / 9;
    final transitionHeight = fontSize * 10 / 8.5;

    // Colon Widget
    final colonWidget = Container(
      width: colonWidth,
      child: AspectRatio(
        aspectRatio: 1 / 1.1,
        child: SvgPicture.asset(
          'assets/COLON.svg',
          alignment: Alignment.center,
          fit: BoxFit.contain,
        ),
      ),
    );

    return GestureDetector(
      onTap: () {}, // Disables weird clock area on tap size increase behavior
      child: Container(
        width: mediaWidth,
        height: mediaHeight,
        color: colors[_Element.background],
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              isHour0Same
                  ? GetSVG(
                      width: svgWidth,
                      number: int.parse(hour[0]),
                    )
                  : RotateNumber(
                      svgWidth: svgWidth,
                      rotateNumber: hour[0],
                      transitionHeight: transitionHeight,
                    ),
              isHour1Same
                  ? GetSVG(
                      width: svgWidth,
                      number: int.parse(hour[1]),
                    )
                  : RotateNumber(
                      svgWidth: svgWidth,
                      rotateNumber: hour[1],
                      transitionHeight: transitionHeight,
                    ),
              colonWidget,
              isMinute0Same
                  ? GetSVG(
                      width: svgWidth,
                      number: int.parse(minute[0]),
                    )
                  : RotateNumber(
                      svgWidth: svgWidth,
                      rotateNumber: minute[0],
                      transitionHeight: transitionHeight,
                    ),
              RotateNumber(
                svgWidth: svgWidth,
                rotateNumber: minute[1],
                transitionHeight: transitionHeight,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
