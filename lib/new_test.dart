import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'BluetoothDeviceListEntry.dart';

// import 'bluetooth_controller.dart';

class NewTestPage extends StatefulWidget {
  const NewTestPage({super.key});

  @override
  State<NewTestPage> createState() => _NewTestPageState();
}

class _NewTestPageState extends State<NewTestPage> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _reason = '';
  String _address = '';
  // DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        shadowColor: Colors.black,
        title: const Text(
          "New Test",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5.5,
        actions: [
          IconButton(
            onPressed: () => GoRouter.of(context).go('view_all_previous_tests'),
            icon: const Icon(Icons.science_outlined),
          ),
          IconButton(
            onPressed: () => {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 4) {
            setState(() {
              _currentStep += 1;
            });
          } else {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              GoRouter.of(context).go('waiting_screen');
            }
          }
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
            title: const Text('Power on the Device'),
            content: const Text(
                'Press the power button on the device to turn it on.'),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Connect to the Device'),
            content: Column(
              children: [
                const Text(
                    'Turn on Bluetooth and connect to the device. The device name is CHOLERA ALERT DEVICE.'),
                ElevatedButton(
                  onPressed: () => GoRouter.of(context).go('/bluetooth_scan'),
                  child: const Text('Connect to Device'),
                ),
              ],
            ),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          ),
          Step(
            title: const Text('Prepare Water Sample'),
            content: const Text(
                'Add the water sample to the device and press the button to start the test.'),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
          ),
          // Step(
          //   title: const Text('Fill in the Form'),
          //   content: Form(
          //     key: _formKey,
          //     child: Column(
          //       children: [
          //         TextFormField(
          //           decoration: const InputDecoration(labelText: 'Name'),
          //           validator: (value) {
          //             if (value == null || value.isEmpty) {
          //               return 'Please enter your name';
          //             }
          //             return null;
          //           },
          //           onSaved: (value) {
          //             if (value != null) {
          //               _name = value;
          //             }
          //           },
          //         ),
          //         TextFormField(
          //           decoration: const InputDecoration(labelText: 'Reason for Test'),
          //           validator: (value) {
          //             if (value == null || value.isEmpty) {
          //               return 'Please enter the reason for the test';
          //             }
          //             return null;
          //           },
          //           onSaved: (value) {
          //             if (value != null) {
          //               _reason = value;
          //             }
          //           },
          //         ),
          //         TextFormField(
          //           decoration: const InputDecoration(labelText: 'Address'),
          //           validator: (value) {
          //             if (value == null || value.isEmpty) {
          //               return 'Please enter your address';
          //             }
          //             return null;
          //           },
          //           onSaved: (value) {
          //             if (value != null) {
          //               _address = value;
          //             }
          //           },
          //         ),
          //         SizedBox(height: 30.0),
          //         InputDatePickerFormField(
          //           fieldLabelText: 'Date',
          //           initialDate: _date,
          //           firstDate: DateTime(2000),
          //           lastDate: DateTime(2100),
          //           onDateSaved: (value) {
          //             _date = value;
          //           },
          //         ),
          //       ],
          //     ),
          //   ),
          //   isActive: _currentStep >= 3,
          //   state: _currentStep > 3 ? StepState.complete : StepState.indexed,
          // ),
          Step(
            title: const Text('Start Test'),
            content: const Text(
                'Press the start button to begin the test. The test will take 30 min. Please wait.'),
            isActive: _currentStep >= 4,
            state: _currentStep > 4 ? StepState.complete : StepState.indexed,
          ),
        ],
      ),
    );
  }
}
