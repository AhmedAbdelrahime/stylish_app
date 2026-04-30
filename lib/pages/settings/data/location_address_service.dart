import 'dart:async';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class DetectedAddress {
  const DetectedAddress({
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.pincode,
    required this.latitude,
    required this.longitude,
  });

  factory DetectedAddress.fromPlacemark({
    required Placemark placemark,
    required double latitude,
    required double longitude,
  }) {
    final streetParts = _uniqueFilled([
      placemark.name,
      placemark.street,
      placemark.subLocality,
      placemark.thoroughfare,
      placemark.subThoroughfare,
    ]);

    return DetectedAddress(
      address: streetParts.join(', '),
      city: _firstFilled([placemark.locality, placemark.subAdministrativeArea]),
      state: placemark.administrativeArea ?? '',
      country: placemark.country ?? '',
      pincode: placemark.postalCode ?? '',
      latitude: latitude,
      longitude: longitude,
    );
  }

  final String address;
  final String city;
  final String state;
  final String country;
  final String pincode;
  final double latitude;
  final double longitude;

  static String _firstFilled(List<String?> values) {
    for (final value in values) {
      final trimmed = value?.trim() ?? '';
      if (trimmed.isNotEmpty) return trimmed;
    }
    return '';
  }

  static List<String> _uniqueFilled(List<String?> values) {
    final seen = <String>{};
    final parts = <String>[];

    for (final value in values) {
      final trimmed = value?.trim() ?? '';
      if (trimmed.isEmpty) continue;

      final key = trimmed.toLowerCase();
      if (seen.add(key)) parts.add(trimmed);
    }

    return parts;
  }
}

class LocationAddressException implements Exception {
  const LocationAddressException(this.message);

  final String message;

  @override
  String toString() => message;
}

class LocationAddressService {
  Future<DetectedAddress> detectCurrentAddress() async {
    final position = await currentPosition();
    return reverseGeocode(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  Future<Position> currentPosition() async {
    final isEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isEnabled) {
      throw const LocationAddressException(
        'Turn on location services to detect your address.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw const LocationAddressException(
        'Location permission is needed to detect your address.',
      );
    }

    if (permission == LocationPermission.deniedForever) {
      throw const LocationAddressException(
        'Location permission is blocked. Enable it from app settings.',
      );
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(const Duration(seconds: 20));
    } on TimeoutException {
      throw const LocationAddressException(
        'Location detection took too long. Try again.',
      );
    }
  }

  Future<DetectedAddress> reverseGeocode({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      ).timeout(const Duration(seconds: 15));

      if (placemarks.isEmpty) {
        return DetectedAddress(
          address:
              '${latitude.toStringAsFixed(6)}, ${longitude.toStringAsFixed(6)}',
          city: '',
          state: '',
          country: '',
          pincode: '',
          latitude: latitude,
          longitude: longitude,
        );
      }

      return DetectedAddress.fromPlacemark(
        placemark: placemarks.first,
        latitude: latitude,
        longitude: longitude,
      );
    } on TimeoutException {
      throw const LocationAddressException(
        'Address lookup took too long. Try again.',
      );
    } on LocationServiceDisabledException {
      throw const LocationAddressException(
        'Turn on location services to detect your address.',
      );
    } catch (_) {
      throw const LocationAddressException(
        'Could not read this address. Try another location.',
      );
    }
  }
}
