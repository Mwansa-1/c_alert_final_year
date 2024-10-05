// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:c_alert/report_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';

import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DetailPage extends StatefulWidget {
  final BluetoothDevice server;

  const DetailPage({required this.server});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _reason = '';
  String _address = '';
  DateTime _date = DateTime.now();

  String? _savedImagePath; // To store the saved image path

  // This is for the for converting the bytes to an image

  BluetoothConnection? connection;
  bool isConnecting = true;

  bool get isConnected => connection != null && connection!.isConnected;
  bool isDisconnecting = false;

  String _selectedFrameSize = '0';

  List<List<int>> chunks = <List<int>>[];
  int contentLength = 0;
  Uint8List? _bytes;
  // static final _image = MemoryImage(_bytes!);

  RestartableTimer? _timer;

  @override
  void initState() {
    super.initState();
    _getBTConnection();
    _timer = RestartableTimer(Duration(seconds: 1), _drawImage);
  }

  @override
  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  _getBTConnection() {
    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
      connection!.input!.listen(_onDataReceived).onDone(() {
        if (isDisconnecting) {
          print('Disconnecting locally');
        } else {
          print('Disconnecting remotely');
        }
        if (mounted) {
          setState(() {});
        }
        Navigator.of(context).pop();
      });
    }).catchError((error) {
      Navigator.of(context).pop();
    });
  }

  _drawImage() {
    if (chunks.isEmpty || contentLength == 0) return;

    _bytes = Uint8List(contentLength);
    int offset = 0;
    for (final List<int> chunk in chunks) {
      _bytes!.setRange(offset, offset + chunk.length, chunk);
      offset += chunk.length;
    }

    setState(() {});

    // call the save image function

    // Show message (you can replace this with a custom loader if needed)
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text("Receiving Data...")),
    // );

    contentLength = 0;
    chunks.clear();
  }

  // function to save the image to the local storage of the phone

  // Future<void> _saveImage(Uint8List bytes) async {
  //   try {
  //     // Get the directory to save the file
  //     final directory = await getApplicationDocumentsDirectory();

  //     // Create a unique filename for the image
  //     String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';

  //     // Construct the full file path
  //     final filePath = '${directory.path}/$fileName';

  //     // Write the bytes to a file
  //     final file = File(filePath);
  //     await file.writeAsBytes(bytes);

  //     // Notify the user
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Image saved to $filePath')),
  //     );
  //   } catch (e) {
  //     print('Error saving image: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to save image')),
  //     );
  //   }
  // }

  Future<String> _saveImage(Uint8List bytes) async {
    try {
      // Get external storage directory (Android only)
      final directory = await getExternalStorageDirectory();

      // Create a unique filename for the image
      String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';

      // Construct the full file path
      final filePath = '${directory!.path}/$fileName';

      // Write the bytes to a file
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      // Notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image saved to $filePath')),
      );

      return filePath; // Return the file path here
    } catch (e) {
      print('Error saving image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save image')),
      );
      throw Exception('Error saving image');
    }
  }

  void _onDataReceived(Uint8List data) {
    chunks.add(data);
    contentLength += data.length;
    _timer?.reset();
    print(data);
  }

  void _sendMessage(String text) async {
    text = text.trim();
    if (text.isNotEmpty) {
      try {
        connection?.output.add(utf8.encode(text));
        // Show loading
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text("Sending Data...")),
        // );
        await connection?.output.allSent;
      } catch (e) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shadowColor: Colors.black,
        title: isConnecting
            ? Text('Loading ...',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ))
            : isConnected
                ? Text('Submitting Test',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ))
                : Text('Disconnected with ${widget.server.name}'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5.5,
        actions: [
          IconButton(
              onPressed: () =>
                  GoRouter.of(context).go('/view_all_previous_tests'),
              icon: Icon(Icons.science_outlined)),
          PopupMenuButton<String>(
            onSelected: (String value) {
              switch (value) {
                case 'New Test':
                  context.go("/new_test");
                  break;
                case 'Language':
                  // Handle Language change here
                  break;
                case 'Settings':
                  // Navigate to Settings page
                  break;
                case 'Sign In':
                  context.go('/login');
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return {'New Test', 'Language', 'Settings', 'Sign In'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon: Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          setState(() {
            if (_currentStep < 2) {
              _currentStep++;
            } else if (_currentStep == 2) {
              // Check if the form is valid
              if (_formKey.currentState!.validate() &&
                  _savedImagePath != null) {
                _formKey.currentState!.save();

                // Convert the saved image path to a File object
                File imageFile = File(_savedImagePath!);

                // Call the API to submit the form data
                ReportFormApi()
                    .submitReport(
                  name: _name,
                  reasonForTest: _reason,
                  date: _date,
                  address: _address,
                  image: imageFile,
                )
                    .then((_) async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Submitted successfully! You will be directed to the Results page.')),
                  );
                  // navigate to results page after submitting
                  await Future.delayed(Duration(seconds: 5));
                  context.go("/previous_tests");
                }).catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to submit form: $error')),
                  );
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('Please fill in all fields and receive data.')),
                );
              }
            }
          });
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        steps: [
          Step(
            title: const Text('Fill in the Form'),
            content: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) {
                        _name = value;
                      }
                    },
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Reason for Test'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the reason for the test';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) {
                        _reason = value;
                      }
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      if (value != null) {
                        _address = value;
                      }
                    },
                  ),
                  SizedBox(height: 30.0),
                  InputDatePickerFormField(
                    fieldLabelText: 'Date',
                    initialDate: _date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    onDateSaved: (value) {
                      _date = value;
                    },
                  ),
                ],
              ),
            ),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Get the data'),
            content: Column(
              children: [
                const Text('Press the Get Data button to receive the data.'),
                // get the data
                shotButton(),
              ],
            ),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Submit the data'),
            content: const Text(
                'By pressing the continue button, you will submit the data to the server.'),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
        ],
      ),
    );
  }

  Widget photoFrame() {
    return Expanded(
      child: Container(
        width: double.infinity,
        child: _bytes != null
            ? PhotoView(
                enableRotation: true,
                initialScale: PhotoViewComputedScale.covered,
                maxScale: PhotoViewComputedScale.covered * 2.0,
                minScale: PhotoViewComputedScale.contained * 0.8,
                imageProvider: MemoryImage(_bytes!),
              )
            : Container(),
      ),
    );
  }

  Widget shotButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () async {
          for (int i = 0; i < 4; i++) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Receiving Data ($i/4)...")),
            );
            _sendMessage(_selectedFrameSize);
            await Future.delayed(Duration(seconds: 7));
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Received (4/4)")),
          );
          _savedImagePath = await _saveImage(_bytes!);
        },
        child: const Text('Get Data'),
      ),
    );
  }

  Widget selectFrameSize() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'FRAMESIZE',
          hintText: 'Please choose one',
        ),
        value: _selectedFrameSize,
        onChanged: (value) {
          setState(() {
            _selectedFrameSize = value!;
          });
        },
        items: [
          DropdownMenuItem(value: "4", child: Text("1600x1200")),
          DropdownMenuItem(value: "3", child: Text("1280x1024")),
          DropdownMenuItem(value: "2", child: Text("1024x768")),
          DropdownMenuItem(value: "1", child: Text("800x600")),
          DropdownMenuItem(value: "0", child: Text("640x480")),
        ],
      ),
    );
  }
}
