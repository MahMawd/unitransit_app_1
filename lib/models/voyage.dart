import 'package:google_maps_flutter/google_maps_flutter.dart';

class Voyage {
  final String voyageId;
  final String departureTime;
  final String arrivalTime;
  final String fromStation;
  final String toStation;
  final String busId;
  final LatLng fromStationLatLng;
  final LatLng toStationLatLng;

  Voyage({
    required this.voyageId,
    required this.departureTime,
    required this.arrivalTime,
    required this.fromStation,
    required this.toStation,
    required this.busId,
    required this.fromStationLatLng,
    required this.toStationLatLng,
  });}