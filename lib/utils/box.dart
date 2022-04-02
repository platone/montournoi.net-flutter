
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:hexcolor/hexcolor.dart';

import '../models/scorer.dart';
import '../models/team.dart';

class Box {
  static BoxDecoration boxDecorationTeam(Team? team, double width) {
    return Box.boxDecorationColor(HexColor(team?.backgroundColor ?? ""), width);
  }
  static BoxDecoration boxDecorationScorer(Scorer? scorer, double width) {
    return Box.boxDecorationColor(HexColor(scorer?.color ?? ""), width);
  }
  static BoxDecoration boxDecorationString(String color, double width) {
    return Box.boxDecorationColor(HexColor(color), width);
  }
  static BoxDecoration boxDecorationColor(Color color, double width) {
    return BoxDecoration(
      border: Border(
        left: BorderSide(
          color: color,
          width: width,
        ),
      ),
    );
  }
  static BoxDecoration boxDecorationTeams(Team? receiver, Team? visitor, double width) {
    return BoxDecoration(
      border: Border(
        left: BorderSide(
          color: HexColor(receiver?.backgroundColor ?? ""),
          width: width,
        ),
        right: BorderSide(
          color: HexColor(visitor?.backgroundColor ?? ""),
          width: width,
        ),
      ),
    );
  }
}

