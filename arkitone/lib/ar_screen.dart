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
  "truckSerialNumber": "7301234",
  "truckModel": "730",
  "inspectionID": "56748",
  "inspectorName": "John Lauda",
  "inspectionEmployeeID": "EMP001",
  "inspectionDateTime": "2024-08-10T14:30:00Z",
  "inspectionLocation": "Warehouse A",
  "geoCoordinates": "40.7128,-74.0060",
  "serviceMeterHours": 15000,
  "inspectorSignature": "JohnDoeSignature",
  "customerName": "Acme Corp",
  "customerID": "CUST12345",

  "tires": {
    "tirePressure": {
      "leftFront": 32,
      "rightFront": 30,
      "leftRear": 32,
      "rightRear": 30
    },
    "tireCondition": {
      "leftFront": "Good",
      "rightFront": "Ok",
      "leftRear": "Needs Replacement",
      "rightRear": "Good"
    },
    "overallTireSummary": "All tires are in good condition except the left rear which needs replacement.",
    "attachedImages": [
      "tire1.jpg",
      "tire2.jpg",
      "tire3.jpg",
      "tire4.jpg"
    ]
  },

  "battery": {
    "batteryMake": "CAT",
    "batteryReplacementDate": "2023-12-01T00:00:00Z",
    "batteryVoltage": "12V",
    "batteryWaterLevel": "Good",
    "batteryCondition": "N",
    "batteryLeakOrRust": "N",
    "batterySummary": "The battery is in good condition with no leaks or rust.",
    "attachedImages": [
      "battery1.jpg"
    ]
  },

  "exterior": {
    "rustDentOrDamage": "Y",
    "oilLeakInSuspension": "N",
    "exteriorSummary": "There is some minor rust and a small dent on the rear bumper.",
    "attachedImages": [
      "exterior1.jpg",
      "exterior2.jpg"
    ]
  },

  "brakes": {
    "brakeFluidLevel": "Ok",
    "brakeConditionFront": "Good",
    "brakeConditionRear": "Ok",
    "emergencyBrake": "Good",
    "brakeSummary": "Brakes are in good condition overall.",
    "attachedImages": [
      "brakes1.jpg"
    ]
  },

  "engine": {
    "rustDentOrDamage": "N",
    "engineOilCondition": "Good",
    "engineOilColor": "Clean",
    "brakeFluidCondition": "Good",
    "brakeFluidColor": "Clean",
    "oilLeakInEngine": "N",
    "engineSummary": "Engine is in good condition with no signs of rust or leaks.",
    "attachedImages": [
      "engine1.jpg"
    ]
  },

  "voiceOfCustomer": {
    "customerFeedback": "The inspection was thorough and well documented.",
    "attachedImages": [
      "feedback1.jpg"
    ]
  }
};
  String _currentField = 'truckSerialNumber';
  List<dynamic> _logData = [];
  bool _isSpeaking = false;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _loadLogData();
    _formData['inspectionDateTime'] = DateTime.now().toIso8601String();
    _speakCurrentField();
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
    await _flutterTts.speak(
        "Current field is $_currentField. The current value is ${_formData[_currentField]}. Please speak the new value or say next or previous.");
    _isSpeaking = false;
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
          onResult: (result) {
            if (result.finalResult) {
              setState(() {
                _text = result.recognizedWords;
                _processVoiceInput(_text, result.confidence);
              });
            }
          },
        );
      }
    }
  }

  void _processVoiceInput(String text, double confidence) async {
    if (confidence < 0.5) {
      print('Low confidence input ignored: $text (confidence: $confidence)');
      return;
    }

    text = text.toLowerCase();
    if (text.contains('next')) {
      _moveToNextField();
    } else if (text.contains('previous')) {
      _moveToPreviousField();
    } else {
      setState(() {
        _formData[_currentField] = text;
      });
      await _speakText('Value recorded for $_currentField: $text');
    }
  }

  void _moveToNextField() async {
    List<String> fields = _formData.keys.toList();
    int currentIndex = fields.indexOf(_currentField);
    if (currentIndex < fields.length - 1) {
      setState(() => _currentField = fields[currentIndex + 1]);
      await _speakCurrentField();
    } else {
      await _speakText(
          'This is the last field. Say previous to go back or finish to complete the form.');
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
        List<String> keys = field.split('.');
        Map<String, dynamic> current = _formData;
        for (int i = 0; i < keys.length - 1; i++) {
          current = current[keys[i]];
        }
        if (current[keys.last] is List) {
          current[keys.last].add(image.path);
        } else {
          current[keys.last] = [image.path];
        }
      });
    }
  }

  Future<void> _finishForm() async {
    final formattedData = {
      'timestamp': DateTime.now().toIso8601String(),
      'action': 'form_finished',
      'data': _formData,
    };
    _logData.add(formattedData);

    // Log form data to console before sending
    print('Form data before sending:');
    print(json.encode(_formData));

    print('Updated log data:');
    print(json.encode(_logData));

    // Print full request payload
    print('Full request payload:');
    print(json.encode(formattedData));

    int retryCount = 0;
    const maxRetries = 3;

    while (retryCount < maxRetries) {
      try {
        final response = await http
            .post(
              Uri.parse('https://public-clubs-dance.loca.lt/api/inspections'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode(formattedData),
            )
            .timeout(Duration(seconds: 10)); // Add a timeout

        if (response.statusCode == 200) {
          print('Data sent successfully');
          print('Server response: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Form finished and data sent to server')),
          );
          return; // Exit the function if successful
        } else {
          print('Failed to send data. Status code: ${response.statusCode}');
          print('Server response: ${response.body}');
          print('Response headers: ${response.headers}');

          // Check if it's a server error (5xx status code)
          if (response.statusCode >= 500) {
            retryCount++;
            if (retryCount < maxRetries) {
              print('Retrying... Attempt $retryCount of $maxRetries');
              await Future.delayed(
                  Duration(seconds: 2 * retryCount)); // Exponential backoff
              continue; // Retry the request
            }
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send data. Please try again.')),
          );
        }
      } catch (e) {
        print('Error sending data: $e');
        retryCount++;
        if (retryCount < maxRetries) {
          print('Retrying... Attempt $retryCount of $maxRetries');
          await Future.delayed(
              Duration(seconds: 2 * retryCount)); // Exponential backoff
          continue; // Retry the request
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Error sending data. Please check your connection.')),
        );
      }
      break; // Exit the loop if all retries failed
    }

    setState(() {
      _formData = _resetFormData(_formData);
      _currentField = 'truckSerialNumber';
    });
  }

  Map<String, dynamic> _resetFormData(Map<String, dynamic> data) {
    return data.map((key, value) {
      if (value is Map<String, dynamic>) {
        return MapEntry(key, _resetFormData(value));
      } else if (value is List) {
        return MapEntry(key, []);
      } else if (value is int) {
        return MapEntry(key, 0);
      } else if (value is double) {
        return MapEntry(key, 0.0);
      } else if (value is bool) {
        return MapEntry(key, false);
      } else {
        return MapEntry(key, '');
      }
    });
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
              Text('Current field: $_currentField',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              _buildFormFields(),
              SizedBox(height: 20),
              Text('Recognized text: $_text',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
              SizedBox(height: 20),
              Text(
                  'Voice commands: "Next" to move forward, "Previous" to move backward',
                  style: TextStyle(fontSize: 14)),
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
      children: _buildNestedFields(_formData),
    );
  }

  List<Widget> _buildNestedFields(Map<String, dynamic> data,
      {String prefix = ''}) {
    List<Widget> widgets = [];
    data.forEach((key, value) {
      String fullKey = prefix.isEmpty ? key : '$prefix.$key';
      if (value is Map<String, dynamic>) {
        widgets.add(Text(key,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)));
        widgets.addAll(_buildNestedFields(value, prefix: fullKey));
      } else if (value is List && key == 'attachedImages') {
        widgets.add(ElevatedButton(
          onPressed: () => _pickImage(fullKey),
          child: Text('Add Image to $key'),
        ));
        widgets.addAll(value.map<Widget>((path) => Image.file(File(path))));
      } else {
        widgets.add(Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$key: ${value.toString()}', style: TextStyle(fontSize: 16)),
            TextFormField(
              initialValue: value.toString(),
              onChanged: (newValue) {
                _updateNestedValue(fullKey, newValue);
              },
            ),
            SizedBox(height: 10),
          ],
        ));
      }
    });
    return widgets;
  }

  void _updateNestedValue(String key, dynamic value) {
    List<String> keys = key.split('.');
    Map<String, dynamic> current = _formData;
    for (int i = 0; i < keys.length - 1; i++) {
      current = current[keys[i]];
    }
    setState(() {
      current[keys.last] = value;
    });
  }
}
