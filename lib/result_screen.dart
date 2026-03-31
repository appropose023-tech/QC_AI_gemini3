import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gallery_saver_updated/gallery_saver.dart';

class ResultScreen extends StatelessWidget {
  final String processedBase64;
  final int defectCount;

  ResultScreen({
    required this.processedBase64,
    required this.defectCount,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List imgBytes = base64Decode(processedBase64);

    return Scaffold(
      appBar: AppBar(title: Text("Result ($defectCount defects)")),
      body: Column(
        children: [
          Expanded(
            child: Image.memory(imgBytes, fit: BoxFit.contain),
          ),
          ElevatedButton(
            child: Text("Save to Gallery"),
            onPressed: () async {
              await GallerySaver.saveImageBytes(imgBytes, "pcb_output");
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Saved!")));
            },
          ),
        ],
      ),
    );
  }
}
