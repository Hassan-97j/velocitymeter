import 'dart:math';

import 'package:get/get.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MeterController extends GetxController {
  double velocity = 0;
  double highestVelocity = 0.0;

  @override
  void onInit() {
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      onAccelerate(event);
    });
    super.onInit();
  }

  void onAccelerate(UserAccelerometerEvent event) {
    double newVelocity =
        sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

    if ((newVelocity - velocity).abs() < 1) {
      return;
    }

    velocity = newVelocity;

    if (velocity > highestVelocity) {
      highestVelocity = velocity;
    }
    update();
  }
}
