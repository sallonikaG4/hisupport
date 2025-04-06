import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class WaitingScreen extends StatefulWidget {
  final String sessionCode;
  const WaitingScreen({super.key, required this.sessionCode});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isCameraReady = false;
  double _currentZoom = 1.0;
  double _maxZoom = 1.0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    await Permission.camera.request();
    await Permission.microphone.request();

    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      _controller = CameraController(
        _cameras[0],
        ResolutionPreset.high,
        enableAudio: true,
      );

      await _controller!.initialize();

      _maxZoom = await _controller!.getMaxZoomLevel();

      setState(() {
        _isCameraReady = true;
      });
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;

    final lensDirection = _controller!.description.lensDirection;
    final newCamera = _cameras.firstWhere(
      (camera) => camera.lensDirection != lensDirection,
    );

    await _controller!.dispose();
    _controller = CameraController(newCamera, ResolutionPreset.high);
    await _controller!.initialize();

    setState(() {});
  }

  Future<void> _capturePhoto() async {
    if (!_controller!.value.isInitialized) return;

    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/photo_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final image = await _controller!.takePicture();
    await image.saveTo(path);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Photo saved to: $path")),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Session Code: ${widget.sessionCode}")),
      body: _isCameraReady
          ? Stack(
              children: [
                CameraPreview(_controller!),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      Slider(
                        min: 1.0,
                        max: _maxZoom,
                        value: _currentZoom,
                        onChanged: (value) async {
                          setState(() => _currentZoom = value);
                          await _controller!.setZoomLevel(value);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _switchCamera,
                            icon: const Icon(Icons.flip_camera_android),
                            label: const Text("Flip Camera"),
                          ),
                          ElevatedButton.icon(
                            onPressed: _capturePhoto,
                            icon: const Icon(Icons.camera),
                            label: const Text("Capture"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
