

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Mapa extends StatefulWidget {
  String? idTravel;

  Mapa({super.key,  this.idTravel });

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {

  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _marcadores = {};
  late CameraPosition _cameraPosition = const CameraPosition(
            target: LatLng(-3.10719, -60.0261),
            zoom: 15
  );
  final FirebaseFirestore _db = FirebaseFirestore.instance;



  void _onMapCreated( GoogleMapController controller ) {
    _controller.complete( controller );
  }

  void _addMarker(LatLng latLng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    // ignore: prefer_is_empty, unnecessary_null_comparison
    if(placemarks != null && placemarks.length > 0) {
      Placemark address = placemarks[0];
      String? street = address.thoroughfare;

      Marker marcador = Marker(
        markerId: MarkerId('marcador-${latLng.latitude}-${latLng.longitude}'),
        position: latLng,
        infoWindow: InfoWindow(
          title: street
        ) 
      );

      setState(() {
        _marcadores.add( marcador );

        // ignore: prefer_collection_literals
        Map<String, dynamic> viagem = Map();
        viagem['titulo'] = street;
        viagem['latitude'] = latLng.latitude;
        viagem['longitude'] = latLng.longitude;

        _db.collection('viagens')
        .add(viagem);
      });

    }

  }

  void _moveCamera() async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        _cameraPosition
      )
    );
  }

  void _addListenerLocation() {
    var locationSettings = const LocationSettings(accuracy: LocationAccuracy.high);
    Geolocator.getPositionStream( locationSettings: locationSettings ).listen((Position? position) {
      setState(() {
        _cameraPosition = CameraPosition(
          target: LatLng(position!.latitude, position.longitude),
          zoom: 15
        );
        _moveCamera();
      });
    });
  }

  void _getTravelId( String? idTravel ) async {

    if( idTravel != null ) {

      DocumentSnapshot documentSnapshot = await _db.collection('viagens')
      .doc( idTravel ).get();
      var data = documentSnapshot.data() as Map<String, dynamic>;

      String titulo = data['titulo'];
      LatLng latLng = LatLng(
        data['latitude'], 
        data['longitude']
        );

      setState(() {

        Marker marcador = Marker(
          markerId: MarkerId('marcador-${latLng.latitude}-${latLng.longitude}'),
          position: latLng,
          infoWindow: InfoWindow(
            title: titulo,
          ) 
        );
        
        _marcadores.add(marcador);
        _cameraPosition = CameraPosition(target: latLng, zoom: 18);
        _moveCamera();
      });
    }else {
      _addListenerLocation();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getTravelId( widget.idTravel );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa'),
      ),
      body: Container(
        child: GoogleMap(
          initialCameraPosition: _cameraPosition,
          markers: _marcadores,
          onMapCreated: _onMapCreated,
          onLongPress: _addMarker,
        ),
      ),
    );
  }
}