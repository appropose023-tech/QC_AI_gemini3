import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

void main() => runApp(MaterialApp(home: PCBInspectorApp()));

class PCBInspectorApp extends StatefulWidget {
  @override
  _PCBInspectorAppState createState() => _PCBInspectorAppState();
}

class _PCBInspectorAppState extends State<PCBInspectorApp> {
  File? _image;
  String? _selectedProject = "Solar_Project"; // Matches your Flask setup
  String _batchNumber = "";
  String _status = "Ready";
  String? _reportUrl;

  final String serverIp = "http://104.154.76.47:5000"; // USE YOUR CLOUD IP

  Future<void> _pickAndUpload() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() { _image = File(pickedFile.path); _status = "Analyzing..."; });

      var request = http.MultipartRequest('POST', Uri.parse('$serverIp/inspect'));
      request.fields['project_name'] = _selectedProject!;
      request.fields['batch_number'] = _batchNumber;
      request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        var respBody = await response.stream.bytesToString();
        var data = json.decode(respBody);
        setState(() {
          _status = data['status'];
          _reportUrl = serverIp + data['report_url'];
        });
      } else {
        setState(() { _status = "Server Error"; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AOI Mobile Inspector")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Batch Number"),
                onChanged: (val) => _batchNumber = val,
              ),
              DropdownButton<String>(
                value: _selectedProject,
                items: ["Solar_Project", "UPS_Project"].map((String value) {
                  return DropdownMenuItem<String>(value: value, child: Text(value));
                }).toList(),
                onChanged: (val) => setState(() => _selectedProject = val),
              ),
              ElevatedButton(onPressed: _pickAndUpload, child: Text("Capture & Inspect")),
              Text("Status: $_status", style: TextStyle(fontWeight: FontWeight.bold)),
              if (_reportUrl != null) 
                Image.network(_reportUrl!, key: ValueKey(_reportUrl)),
            ],
          ),
        ),
      ),
    );
  }
}
