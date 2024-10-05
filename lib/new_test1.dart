import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'BluetoothDeviceListEntry.dart';

// import 'bluetooth_controller.dart';

class NewTestPage1 extends StatefulWidget {
  final BluetoothDevice device; // Add this line to accept BluetoothDevice

  const NewTestPage1({super.key, required this.device}); // Add 'required'

  @override
  State<NewTestPage1> createState() => _NewTestPage1State();
}

class _NewTestPage1State extends State<NewTestPage1> {
  int _currentStep = 2;
  final _formKey = GlobalKey<FormState>();
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
          setState(() {
            if (_currentStep < 3) {
              _currentStep++;
            } else if (_currentStep == 3) {
              GoRouter.of(context).go('/waiting_page', extra: widget.device);
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
                const Text('You have successfully connected to the device.'),
                const Text('Please proceed to the next step.'),
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
          Step(
            title: const Text('Start Test'),
            content: const Text(
                'Press the start button to begin the test. The test will take 30 min. Please wait.'),
            isActive: _currentStep >= 3,
            state: _currentStep > 3 ? StepState.complete : StepState.indexed,
          ),
        ],
      ),
    );
  }
}
