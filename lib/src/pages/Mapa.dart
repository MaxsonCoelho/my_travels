import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class Mapa extends StatefulWidget {
  const Mapa({super.key});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {

  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _marcadores = {};

  void _onMapCreated( GoogleMapController controller ) {
    _controller.complete( controller );
  }

  void _getMarker(LatLng latLng) {
    Marker marcador = Marker(
      markerId: MarkerId('marcador-${latLng.latitude}-${latLng.longitude}'),
      position: latLng,
      infoWindow: const InfoWindow(
        title: 'Marcador'
      ) 
    );

    setState(() {
      _marcadores.add( marcador );
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
      ),
      body: Container(
        child: GoogleMap(
          initialCameraPosition: const CameraPosition(
            target: LatLng(-23.562436, -46655005),
            zoom: 18
          ),
          markers: _marcadores,
          onMapCreated: _onMapCreated,
          onLongPress: _getMarker,
        ),
      ),
    );
  }
}