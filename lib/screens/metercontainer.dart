import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:velocitymeter/screens/components/speedometer.dart';
import 'package:velocitymeter/screens/controller/metercontroller.dart';

// ignore: must_be_immutable
class SpeedometerContainer extends StatelessWidget {
  SpeedometerContainer({Key? key}) : super(key: key);
  MeterController meterController = Get.put(MeterController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MeterController>(
      init: MeterController(),
      initState: (_) {},
      builder: (_) {
        return Scaffold(
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  padding: const EdgeInsets.only(bottom: 64),
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Speed:\n${meterController.velocity.toStringAsFixed(2)} km/h',
                    style: TextStyle(
                      color: Get.theme.primaryColorDark,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  )),
              Container(
                  padding: const EdgeInsets.only(bottom: 64),
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'Highest speed:\n${meterController.highestVelocity.toStringAsFixed(2)} km/h',
                    style: TextStyle(color: Get.theme.primaryColorDark),
                    textAlign: TextAlign.center,
                  )),
              Speedometer(
                speed: meterController.velocity,
                speedRecord: meterController.highestVelocity,
              )
            ],
          ),
        );
      },
    );
  }
}
