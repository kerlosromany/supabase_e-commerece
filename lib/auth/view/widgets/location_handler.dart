import 'dart:developer';

import 'package:app_settings/app_settings.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../../../core/helpers/temporary_vars.dart';

class LocationHandlerWidget extends StatefulWidget {
  const LocationHandlerWidget({super.key});

  @override
  State<LocationHandlerWidget> createState() => _LocationHandlerWidgetState();
}

class _LocationHandlerWidgetState extends State<LocationHandlerWidget> {
  Location location = Location();
  LocationData? _locationData;
  bool _serviceEnabled = false;
  PermissionStatus _permissionGranted = PermissionStatus.denied;
  String errorMessage = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      // Check if location services are enabled
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          throw 'يرجى السماح للتطبيق بالوصول إلى موقعك الجغرافي لتسهيل تحديد عنوانك بدقة';
        }
      }

      // Check location permission
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted == PermissionStatus.denied) {
          throw 'يرجى السماح للتطبيق بالوصول إلى موقعك الجغرافي لتسهيل تحديد عنوانك بدقة';
        }
      }

      // Handle 'denied forever' scenario
      if (_permissionGranted == PermissionStatus.deniedForever) {
        // Show dialog prompting user to manually enable permissions
        _showPermissionDialog();
        return;
      }

      // Get current location
      _locationData = await location.getLocation();
      TemporaryVars.lat = _locationData?.latitude;
      TemporaryVars.lng = _locationData?.longitude;
      log("${TemporaryVars.lat}");
      log("${TemporaryVars.lng}");

      setState(() {
        errorMessage = "";
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Show a dialog asking the user to open app settings
  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text(
              'Location permission is permanently denied. Please enable it in your app settings.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await AppSettings.openAppSettings(
                    type: AppSettingsType.location);
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : _locationData != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AutoSizeText(
                      "تم تحديد موقعك بدقة",
                      style: TextStyle(color: Colors.green),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 20),
                    errorMessage.isNotEmpty
                        ? ElevatedButton(
                            onPressed: _initializeLocation,
                            child: const Text('Refresh Location'),
                          )
                        : const SizedBox(),
                  ],
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: _locationData != null
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    _locationData != null
                        ? AutoSizeText(
                            errorMessage.isNotEmpty
                                ? 'يرجى السماح للتطبيق بالوصول إلى موقعك الجغرافي لتسهيل تحديد عنوانك بدقة'
                                : "",
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          )
                        : const SizedBox(),
                    SizedBox(height: _locationData != null ? 20 : 0),
                    ElevatedButton(
                      onPressed: _initializeLocation,
                      child: const AutoSizeText('حاول مرة اخري التقاط موقعك',maxLines: 1,),
                    ),
                  ],
                ),
              );
  }
}
