import 'package:flutter/material.dart';
import 'package:unitransit_app_1/components/voyages_widget.dart';
import 'package:unitransit_app_1/models/voyage.dart';

class PageVoyages extends StatelessWidget{
  final List<Voyage> voyages;
  const PageVoyages({
    super.key,
    required this.voyages
    });

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: const Text('choose your route'),),
      body: voyages.isNotEmpty ? 
      ListView.separated(
        itemBuilder:(context, index) {
          Voyage aVoyage = voyages[index];
          return VoyagesWidget(
            voyage: aVoyage,
          );
        }, 
        separatorBuilder: (context,index){return const SizedBox(height: 10,);}, 
        itemCount: voyages.length
        )
      : const Text('no routes available'),
    );
  }
}