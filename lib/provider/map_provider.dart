import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';
import 'package:story_app/model/response/error_response.dart';

class MapProvider extends ChangeNotifier {
  final Set<Marker> _markers = {};
  MapType _selectedMapType = MapType.normal;
  geo.Placemark? _placemark;

  Set<Marker> get markers => _markers;
  MapType get selectedMapType => _selectedMapType;
  geo.Placemark? get placemark => _placemark;

  void onGetMyLocation(GoogleMapController mapController) async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();

      if (!serviceEnabled) {
        throw ErrorResponse(error: true, message: 'Service location disabled');
      }
    }

    permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();

      if (permissionGranted != PermissionStatus.granted) {
        throw ErrorResponse(error: true, message: 'Permission location denied');
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

    _placemark = place;
    notifyListeners();

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

    _markers.add(marker);
    notifyListeners();
  }

  void onLongPressGoogleMaps(
      LatLng latLng, GoogleMapController mapController) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    _placemark = place;
    notifyListeners();

    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void addMarker(Marker markers) {
    _markers.add(markers);
    notifyListeners();
  }

  void changeMapType(MapType mapType) {
    _selectedMapType = mapType;
    notifyListeners();
  }

  void onMapTypeButtonPressed() {
    notifyListeners();
  }
}
