import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class YerleriHaritadaGoster extends StatefulWidget {
  final double enlem;
  final double boylam;
  final String mekanIsmi;

  const YerleriHaritadaGoster({Key? key, required this.enlem, required this.boylam, required this.mekanIsmi}) : super(key: key);

  @override
  State<YerleriHaritadaGoster> createState() => YerleriHaritadaGosterState();
}

class YerleriHaritadaGosterState extends State<YerleriHaritadaGoster> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Haritada Göster")),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.enlem, widget.boylam), // widget üzerinden erişim
          zoom: 13.5,
        ),
        markers: {
          Marker(
            markerId: MarkerId('mekan'),  // Marker ID tanımlaması
            position: LatLng(widget.enlem, widget.boylam),  // Konum bilgisi
            infoWindow: InfoWindow(title: widget.mekanIsmi,),  // Info penceresi
          ),
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);  // Harita oluşturulunca controller tamamlanır
        },
      ),
    );
  }
}
