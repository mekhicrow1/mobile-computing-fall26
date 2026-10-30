import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DevicePracticeScreen(),
    ),
  );
}


class DevicePracticeScreen extends StatefulWidget {
  const DevicePracticeScreen({super.key});

  @override
  State<DevicePracticeScreen> createState() =>
      _DevicePracticeScreenState();
}

class _DevicePracticeScreenState
    extends State<DevicePracticeScreen> {
  final ImagePicker _picker = ImagePicker();

  File? _image;
  Position? _position;

  bool _isLoadingLocation = false;
  String? _errorMessage;

  // Take a picture or select one from the gallery.
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      setState(() {
        _image = File(pickedFile.path);
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to select image: $e')),
      );
    }
  }

  // Check and request location permissions.
  Future<void> _getLocation() async {
    setState(() {
      _isLoadingLocation = true;
      _errorMessage = null;
    });

    try {
      // Check whether location services are enabled.
      bool serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception(
          'Location services are disabled. Please turn on GPS.',
        );
      }

      // Check current permission.
      LocationPermission permission =
      await Geolocator.checkPermission();

      // Request permission if it has not been granted.
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception('Location permission was denied.');
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permission is permanently denied. '
              'Please enable it in your app settings.',
        );
      }

      // Get the current device location.
      Position currentPosition =
      await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 30),
        ),
      );

      if (!mounted) return;

      setState(() {
        _position = currentPosition;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text(
          'Device Practice',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[800],
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // Introduction
            const Text(
              'Photo & Location',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Take a picture and find your current location.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 25),

            // Photo display area
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade300),
              ),

              child: _image != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  _image!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
                  : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 75,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'No photo selected',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Camera button
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take a Picture'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[800],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(15),
              ),
            ),

            const SizedBox(height: 10),

            // Gallery button
            ElevatedButton.icon(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
              label: const Text('Choose from Gallery'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(15),
              ),
            ),

            const SizedBox(height: 30),

            const Divider(),

            const SizedBox(height: 15),

            // Location heading
            const Text(
              'Your Current Location',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 15),

            // Location information card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade300),
              ),

              child: _isLoadingLocation
                  ? const Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Getting your location...'),
                ],
              )
                  : _errorMessage != null
                  ? Column(
                children: [
                  const Icon(
                    Icons.location_off,
                    size: 45,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              )
                  : _position != null
                  ? Column(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 45,
                    color: Colors.green,
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Latitude: ${_position!.latitude}',
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Longitude: ${_position!.longitude}',
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Accuracy: ${_position!.accuracy.toStringAsFixed(1)} meters',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              )
                  : const Column(
                children: [
                  Icon(
                    Icons.location_searching,
                    size: 45,
                    color: Colors.blue,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Location has not been requested yet.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // Get location button
            ElevatedButton.icon(
              onPressed:
              _isLoadingLocation ? null : _getLocation,
              icon: const Icon(Icons.my_location),
              label: const Text('Get My Location'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(15),
              ),
            ),

            const SizedBox(height: 15),

            // Refresh location button
            OutlinedButton.icon(
              onPressed:
              _isLoadingLocation || _position == null
                  ? null
                  : _getLocation,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh Location'),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
