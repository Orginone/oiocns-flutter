import 'dart:math' as math show sin, pi;

import 'package:flutter/animation.dart';

class DelayTween extends Tween<double> {
   double delay;

  DelayTween({begin, end, this.delay = 0}) : super(begin: begin, end: end);


  @override
  double lerp(double t) => super.lerp((math.sin((t - delay) * 2 * math.pi) + 1) / 2);

  @override
  double evaluate(Animation<double> animation) => lerp(animation.value);
}
