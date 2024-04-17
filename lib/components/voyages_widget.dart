import 'package:flutter/material.dart';
import 'package:unitransit_app_1/models/voyage.dart';

class VoyagesWidget extends StatelessWidget {
  const VoyagesWidget({
    super.key,
    required this.voyage
    });
  final Voyage voyage;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(8.0),
          //   border: Border.all(width: 2.0)
          //   ),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: [
              Text('Departure:${voyage.departureTime}'),
              Text('From:${voyage.fromStation}'),
              Text('To:${voyage.toStation}'),
              Wrap(
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton(onPressed: (){}, child: const Text('Start')),
                  ElevatedButton(onPressed: (){}, child: const Text('Runnning late')),
                  ElevatedButton(onPressed: (){}, child: const Text('Malfunction')),
                  ElevatedButton(onPressed: (){}, child: const Text('Arrived')),
                ],
              )
              
            ],),
        )
      ],);
  }
}