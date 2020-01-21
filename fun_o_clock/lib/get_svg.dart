import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

enum GetSVGEnum {
  NAN,
  ZERO,
  ONE,
  TWO,
  THREE,
  FOUR,
  FIVE,
  SIX,
  SEVEN,
  EIGHT,
  NINE,
}

class GetSVG extends StatefulWidget {
  final double width;
  final int number;

  const GetSVG({
    Key key,
    @required this.width,
    @required this.number,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return GetSVGState();
  }
}

class GetSVGState extends State<GetSVG> {
  double get _width => widget.width;
  int get _number => widget.number;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      child: AspectRatio(
        aspectRatio: 1 / 1.15,
        child: SvgPicture.asset(
          _getSVGFile(_getEnumNumberEquivalent(_number)),
          alignment: Alignment.center,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  GetSVGEnum _getEnumNumberEquivalent(int number) {
    switch (number) {
      case 0:
        return GetSVGEnum.ZERO;
        break;
      case 1:
        return GetSVGEnum.ONE;
        break;
      case 2:
        return GetSVGEnum.TWO;
        break;
      case 3:
        return GetSVGEnum.THREE;
        break;
      case 4:
        return GetSVGEnum.FOUR;
        break;
      case 5:
        return GetSVGEnum.FIVE;
        break;
      case 6:
        return GetSVGEnum.SIX;
        break;
      case 7:
        return GetSVGEnum.SEVEN;
        break;
      case 8:
        return GetSVGEnum.EIGHT;
        break;
      case 9:
        return GetSVGEnum.NINE;
        break;
      default:
        return GetSVGEnum.NAN;
    }
  }

  String _getSVGFile(GetSVGEnum getSVGEnum) {
    switch (getSVGEnum) {
      case GetSVGEnum.ZERO:
        return "assets/ZERO.svg";
        break;
      case GetSVGEnum.ONE:
        return "assets/ONE.svg";
        break;
      case GetSVGEnum.TWO:
        return "assets/TWO.svg";
        break;
      case GetSVGEnum.THREE:
        return "assets/THREE.svg";
        break;
      case GetSVGEnum.FOUR:
        return "assets/FOUR.svg";
        break;
      case GetSVGEnum.FIVE:
        return "assets/FIVE.svg";
        break;
      case GetSVGEnum.SIX:
        return "assets/SIX.svg";
        break;
      case GetSVGEnum.SEVEN:
        return "assets/SEVEN.svg";
        break;
      case GetSVGEnum.EIGHT:
        return "assets/EIGHT.svg";
        break;
      case GetSVGEnum.NINE:
        return "assets/NINE.svg";
        break;
      default:
        throw Exception("Number Invalid!");
    }
  }
}
