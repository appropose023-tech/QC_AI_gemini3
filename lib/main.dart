import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'result_screen.dart';

List<CameraDescription>? cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(MaterialApp(home: HomeScreen()));
}

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CameraController? controller;

  @override
  void initState() {
    super.initState();
    initCam();
  }

  Future<void> initCam() async {
    controller = CameraController(cameras![0], ResolutionPreset.max);
    await controller!.initialize();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text("PCB Inspector")),
      body: Stack(children: [
        CameraPreview(controller!),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: captureImage,
              child: Text("Capture PCB"),
            ),
          ),
        )
      ]),
    );
  }

  Future<void> captureImage() async {
    final XFile file = await controller!.takePicture();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(imageFile: File(file.path)),
      ),
    );
  }
}
