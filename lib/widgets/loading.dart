import 'package:flutter/material.dart';
import 'package:flutter_spinkit/src/spinning_circle.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const SpinKitSpinningCircle(
          color: Colors.blue,
        ),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          "Memuat, harap tunggu..",
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ],
    );
  }
}
