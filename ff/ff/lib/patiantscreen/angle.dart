import 'dart:async';
import 'dart:math';

class AngleStream {
  Stream<double> getAngleStream() async* {
    final random = Random();
    while (true) {
      // Generate random angle between 0 and 180 degrees
      final angle = random.nextDouble() * 180;
      yield angle;
      await Future.delayed(Duration(seconds: 1));
    }
  }
}
