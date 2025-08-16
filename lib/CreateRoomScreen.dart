import 'package:flutter/material.dart';
import 'package:scribble/paintScreen.dart';
import 'package:scribble/widgets/customTextField.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();
  String? _maxRoundsValue;
  String? _roomSizeValue;

  void createRoom() {
    if (_nameController.text.isNotEmpty &&
        _roomNameController.text.isNotEmpty &&
        _maxRoundsValue != null &&
        _roomSizeValue != null) {
      Map<String, String> data = {
        "nickname": _nameController.text,
        "name": _roomNameController.text,
        "occupancy": _roomSizeValue!,
        "maxRounds": _maxRoundsValue!,
      };
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              PaintScreen(dataa: data, screenFrom: 'createRoom'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Room'),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Setup Your Game',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              CustomTextField(
                hintText: "Enter your name",
                nameController: _nameController,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                hintText: "Enter Room Name",
                nameController: _roomNameController,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelStyle: TextStyle(fontSize: 16, color: Colors.white70),
                  labelText: 'Select Max Rounds',
                ),
                items: <String>["2", "5", "10", "15"]
                    .map<DropdownMenuItem<String>>(
                      (String value) =>
                          DropdownMenuItem(value: value, child: Text(value)),
                    )
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    _maxRoundsValue = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Room Size',
                  labelStyle: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                items: <String>["2", "3", "4", "5", "6", "7", "8"]
                    .map<DropdownMenuItem<String>>(
                      (String value) =>
                          DropdownMenuItem(value: value, child: Text(value)),
                    )
                    .toList(),
                onChanged: (String? value) {
                  setState(() {
                    _roomSizeValue = value;
                  });
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: createRoom,
                child: const Text("Create"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
