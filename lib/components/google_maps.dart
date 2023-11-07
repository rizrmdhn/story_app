import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:story_app/components/placemark.dart';

class MyGoogleMaps extends StatefulWidget {
  const MyGoogleMaps({Key? key}) : super(key: key);

  @override
  State<MyGoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<MyGoogleMaps> {
  final dicodingOffice = const LatLng(-6.8957473, 107.6337669);
  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  MapType selectedMapType = MapType.normal;
  geo.Placemark? placemark;

  void onMyLocationButtonPress() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();

      if (!serviceEnabled) {
        print('Service location disabled');
        return;
      }
    }

    permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();

      if (permissionGranted != PermissionStatus.granted) {
        print('Permission location denied');
        return;
      }
    }

    locationData = await location.getLocation();

    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      placemark = place;
    });

    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );

    setState(() {
      markers.add(marker);
    });
  }

  void onLongPressGoogleMap(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    setState(() {
      placemark = place;
    });

    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            myLocationEnabled: true,
            mapType: selectedMapType,
            markers: markers,
            initialCameraPosition: CameraPosition(
              target: dicodingOffice,
              zoom: 18,
            ),
            onLongPress: (LatLng latLng) {
              onLongPressGoogleMap(latLng);
            },
            onMapCreated: (controller) async {
              final marker = Marker(
                markerId: const MarkerId("source"),
                position: dicodingOffice,
              );

              setState(() {
                mapController = controller;
                markers.add(marker);
              });
            },
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              child: const Icon(Icons.my_location),
              onPressed: () {
                onMyLocationButtonPress();
              },
            ),
          ),
          Positioned(
            top: 16,
            right: 80,
            child: FloatingActionButton.small(
              onPressed: null,
              child: PopupMenuButton<MapType>(
                icon: const Icon(Icons.map),
                onSelected: (value) {
                  setState(() {
                    selectedMapType = value;
                  });
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: MapType.normal,
                    child: Text("Normal"),
                  ),
                  const PopupMenuItem(
                    value: MapType.satellite,
                    child: Text("Satellite"),
                  ),
                  const PopupMenuItem(
                    value: MapType.terrain,
                    child: Text("Terrain"),
                  ),
                  const PopupMenuItem(
                    value: MapType.hybrid,
                    child: Text("Hybrid"),
                  ),
                ],
              ),
            ),
          ),
          if (placemark == null)
            const SizedBox()
          else
            Positioned(
              bottom: 16,
              right: 16,
              left: 16,
              child: Placemark(
                placemark: placemark!,
              ),
            ),
        ],
      ),
    );
  }
}