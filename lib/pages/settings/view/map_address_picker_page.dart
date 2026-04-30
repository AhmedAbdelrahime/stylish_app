import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hungry/core/config/store_config.dart';
import 'package:hungry/core/constants/app_colors.dart';
import 'package:hungry/l10n/app_localizations.dart';
import 'package:hungry/pages/auth/widgets/app_snackbar.dart';
import 'package:hungry/pages/settings/data/location_address_service.dart';

class MapAddressPickerPage extends StatefulWidget {
  const MapAddressPickerPage({super.key});

  @override
  State<MapAddressPickerPage> createState() => _MapAddressPickerPageState();
}

class _MapAddressPickerPageState extends State<MapAddressPickerPage> {
  static const LatLng _fallbackLocation = LatLng(
    StoreLocation.defaultLatitude,
    StoreLocation.defaultLongitude,
  );

  final LocationAddressService _locationService = LocationAddressService();
  GoogleMapController? _mapController;
  LatLng _selectedLocation = _fallbackLocation;
  bool _isLocating = true;
  bool _isSaving = false;
  bool _hasLocationPermission = false;

  @override
  void initState() {
    super.initState();
    _centerOnCurrentLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _centerOnCurrentLocation() async {
    setState(() => _isLocating = true);

    try {
      final position = await _locationService.currentPosition();
      if (!mounted) return;

      final target = LatLng(position.latitude, position.longitude);
      setState(() {
        _selectedLocation = target;
        _hasLocationPermission = true;
      });

      await _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(target, 17),
      );
    } on LocationAddressException catch (error) {
      if (!mounted) return;
      AppSnackBar.show(
        context: context,
        text: error.message,
        backgroundColor: Colors.black87,
      );
    } catch (_) {
      if (!mounted) return;
      AppSnackBar.show(
        context: context,
        text: 'Could not open your current location.',
        backgroundColor: Colors.black87,
      );
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  Future<void> _confirmLocation() async {
    setState(() => _isSaving = true);

    try {
      final address = await _locationService.reverseGeocode(
        latitude: _selectedLocation.latitude,
        longitude: _selectedLocation.longitude,
      );

      if (!mounted) return;
      Navigator.pop(context, address);
    } on LocationAddressException catch (error) {
      if (!mounted) return;
      AppSnackBar.show(
        context: context,
        text: error.message,
        backgroundColor: AppColors.redColor,
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    controller.animateCamera(CameraUpdate.newLatLngZoom(_selectedLocation, 15));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        title: Text(context.tr('Delivery Location')),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.blackColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _fallbackLocation,
              zoom: 14,
            ),
            compassEnabled: true,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: _hasLocationPermission,
            zoomControlsEnabled: false,
            onMapCreated: _onMapCreated,
            onCameraMove: (position) {
              _selectedLocation = position.target;
            },
          ),
          IgnorePointer(
            child: Center(
              child: Transform.translate(
                offset: const Offset(0, -22),
                child: const Icon(
                  Icons.location_pin,
                  color: AppColors.redColor,
                  size: 48,
                ),
              ),
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: FloatingActionButton.small(
                heroTag: 'center_on_current_location',
                backgroundColor: Colors.white,
                foregroundColor: AppColors.redColor,
                onPressed: _isLocating ? null : _centerOnCurrentLocation,
                child: _isLocating
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.redColor,
                        ),
                      )
                    : const Icon(Icons.my_location_rounded),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(
              top: false,
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                elevation: 8,
                shadowColor: Colors.black.withValues(alpha: 0.16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: AppColors.redColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              context.tr('Set delivery address'),
                              style: const TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        context.tr(
                          'Place the pin on the right door or building entrance.',
                        ),
                        style: const TextStyle(
                          color: AppColors.hintColor,
                          fontSize: 12,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _isLocating
                                  ? null
                                  : _centerOnCurrentLocation,
                              icon: const Icon(Icons.my_location_rounded),
                              label: Text(context.tr('GPS')),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.redColor,
                                minimumSize: const Size(0, 46),
                                side: const BorderSide(
                                  color: AppColors.redColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton.icon(
                              onPressed: _isSaving ? null : _confirmLocation,
                              icon: _isSaving
                                  ? const SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Icon(Icons.check_rounded),
                              label: Text(
                                context.tr(
                                  _isSaving ? 'Saving...' : 'Use Address',
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.redColor,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(0, 46),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
