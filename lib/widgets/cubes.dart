import 'package:flutter/material.dart';
import '../constants/constant.dart';
import '../utils/config.dart';
import '../utils/util.dart';

class CubesWidget extends StatelessWidget {
  final String displayElement;
  final int i, j;
  final int bgColor;

  const CubesWidget({
    super.key,
    required this.displayElement,
    required this.i,
    required this.j,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      width: SizeConfig.safeBlockHorizontal * 22,
      height: SizeConfig.safeBlockVertical * 13,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(bgColor),
        border: Util.getBorderSide(i, j),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/images/board.png", fit: BoxFit.contain),
          ),
          Center(
            child: Text(
              displayElement,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: displayElement == 'X'
                    ? Constants.whiteColor
                    : Constants.accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
