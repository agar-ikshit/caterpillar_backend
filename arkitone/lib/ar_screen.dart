import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class VoiceForm extends StatefulWidget {
  @override
  _VoiceFormState createState() => _VoiceFormState();
}

class _VoiceFormState extends State<VoiceForm> {
  stt.SpeechToText _speech = stt.SpeechToText();
  FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
  String _text = '';
  Map<String, dynamic> _formData = {
    'truckSerialNumber': '',
    'truckModel': '',
    'inspectionId': '',
    'inspectorName': '',
    'inspectionEmployeeId': '',
    'inspectionDateTime': '',
    'inspectionLocation': '',
    'geoCoordinates': '',
    'serviceMeterHours': '',
    'inspectorSignature': '',
    'customerName': '',
    'catCustomerId': '',
    'tirePressureLeftFront': '',
    'tirePressureRightFront': '',
    'tireConditionLeftFront': '',
    'tireConditionRightFront': '',
    'tirePressureLeftRear': '',
    'tirePressureRightRear': '',
    'tireConditionLeftRear': '',
    'tireConditionRightRear': '',
    'tireSummary': '',
    'tireImages': [],
    'batteryMake': '',
    'batteryReplacementDate': '',
    'batteryVoltage': '',
    'batteryWaterLevel': '',
    'batteryDamage': false,
    'batteryLeakRust': false,
    'batterySummary': '',
    'batteryImages': [],
    'exteriorDamage': false,
    'suspensionOilLeak': false,
    'exteriorSummary': '',
    'exteriorImages': [],
    'brakeFluidLevel': '',
    'brakeConditionFront': '',
    'brakeConditionRear': '',
    'emergencyBrake': '',
    'brakeSummary': '',
    'brakeImages': [],
    'engineDamage': false,
    'engineOilCondition': '',
    'engineOilColor': '',
    'brakeFluidCondition': '',
    'brakeFluidColor': '',
    'engineOilLeak': false,
    'engineSummary': '',
    'engineImages': [],
    'customerFeedback': '',
    'customerIssueImages': [],
  };

  String _currentField = 'truckSerialNumber';
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  List<dynamic> _logData = [];
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _loadLogData();
    _formData['inspectionId'] = _generateInspectionId();
    _formData['inspectionDateTime'] = DateTime.now().toIso8601String();
    _speakCurrentField();
  }

  String _generateInspectionId() {
    return 'INS${DateTime.now().millisecondsSinceEpoch}';
  }

  Future<void> _requestPermissions() async {
    await Permission.microphone.request();
    await Permission.camera.request();
  }

  Future<void> _loadLogData() async {
    try {
      String jsonString = await rootBundle.loadString('assets/form_log.json');
      setState(() {
        _logData = json.decode(jsonString);
      });
    } catch (e) {
      print('Error loading log data: $e');
      _logData = [];
    }
    _logFormOpening();
  }

  void _logFormOpening() {
    final newEntry = {
      'sessionId': _sessionId,
      'timestamp': DateTime.now().toIso8601String(),
      'action': 'form_opened',
    };
    
    _logData.add(newEntry);
  }

  Future<void> _speakCurrentField() async {
    if (_isSpeaking) {
      await _flutterTts.stop();
    }
    _isSpeaking = true;
    await _flutterTts.speak("Current field is $_currentField. Please speak the value.");
    _isSpeaking = false;
    _startListening();
  }

  void _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          print('onStatus: $status');
          if (status == 'done' || status == 'notListening') {
            setState(() => _isListening = false);
          }
        },
        onError: (error) => print('onError: $error'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) => setState(() {
            _text = result.recognizedWords;
            _processVoiceInput(_text);
          }),
        );
      }
    }
  }

  void _processVoiceInput(String text) async {
    text = text.toLowerCase();
    if (text.contains('next')) {
      _moveToNextField();
    } else if (text.contains('previous')) {
      _moveToPreviousField();
    } else {
      setState(() {
        _formData[_currentField] = text;
      });
      await _speakText('Value recorded. Say next or previous to navigate.');
    }
  }

  void _moveToNextField() async {
    List<String> fields = _formData.keys.toList();
    int currentIndex = fields.indexOf(_currentField);
    if (currentIndex < fields.length - 1) {
      setState(() => _currentField = fields[currentIndex + 1]);
      await _speakCurrentField();
    } else {
      await _speakText('This is the last field. Say previous to go back or finish to complete the form.');
    }
  }

  void _moveToPreviousField() async {
    List<String> fields = _formData.keys.toList();
    int currentIndex = fields.indexOf(_currentField);
    if (currentIndex > 0) {
      setState(() => _currentField = fields[currentIndex - 1]);
      await _speakCurrentField();
    } else {
      await _speakText('This is the first field. Say next to move forward.');
    }
  }

  Future<void> _pickImage(String field) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    
    if (image != null) {
      setState(() {
        if (_formData[field] is List) {
          _formData[field].add(image.path);
        } else {
          _formData[field] = [image.path];
        }
      });
    }
  }

  Future<void> _finishForm() async {
    final newEntry = {
      'sessionId': _sessionId,
      'timestamp': DateTime.now().toIso8601String(),
      'action': 'form_finished',
      'data': _formData,
    };
    
    _logData.add(newEntry);

    print('Updated log data:');
    print(json.encode(_logData));

    try {
      final response = await http.post(
        Uri.parse('https://caterpillar-backend.vercel.app/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(newEntry),
      );

      if (response.statusCode == 200) {
        print('Data sent successfully');
        print('Server response: ${response.body}');
      } else {
        print('Failed to send data. Status code: ${response.statusCode}');
        print('Server response: ${response.body}');
      }
    } catch (e) {
      print('Error sending data: $e');
    }

    setState(() {
      _formData = Map.from(_formData)..updateAll((key, value) => '');
      _currentField = 'truckSerialNumber';
      _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Form finished and data sent to server')),
    );
  }

  Future<void> _speakText(String text) async {
    if (_isSpeaking) {
      await _flutterTts.stop();
    }
    _isSpeaking = true;
    await _flutterTts.speak(text);
    _isSpeaking = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Truck Inspection Form')),
      floatingActionButton: FloatingActionButton(
        onPressed: _startListening,
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current field: $_currentField', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              _buildFormFields(),
              SizedBox(height: 20),
              Text('Recognized text: $_text', style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
              SizedBox(height: 20),
              Text('Voice commands: "Next" to move forward, "Previous" to move backward', style: TextStyle(fontSize: 14)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _finishForm,
                child: Text('Finish and Send Form'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _formData.keys.map((key) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(key, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            if (_formData[key] is bool) ...[
              Switch(
                value: _formData[key],
                onChanged: (value) {
                  setState(() => _formData[key] = value);
                },
              ),
            ] else if (_formData[key] is List) ...[
              ElevatedButton(
                onPressed: () => _pickImage(key),
                child: Text('Pick Image'),
              ),
              SizedBox(height: 10),
              ..._formData[key].map<Widget>((path) => Image.file(File(path))),
            ] else ...[
              TextFormField(
                initialValue: _formData[key].toString(),
                onChanged: (value) {
                  setState(() => _formData[key] = value);
                },
              ),
            ],
            SizedBox(height: 20),
          ],
        );
      }).toList(),
    );
  }
}