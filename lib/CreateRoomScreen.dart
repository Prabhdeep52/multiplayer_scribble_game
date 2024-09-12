import 'package:flutter/material.dart';
import 'package:scribble_game/paintScreen.dart';
import 'package:scribble_game/widgets/customTextField.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();
  String? _maxRoundsValue; // Nullable string to hold the selected value
  String? _roomSizeValue; // Nullable string to hold the selected value
  late IO.Socket _socket;

  @override
  void initState() {
    super.initState();
    connectSocket();
  }

  void connectSocket() {
    // TODO: Implement socket connection logic
  }

  void createRoom() {
    if (_nameController.text.isNotEmpty &&
        _roomNameController.text.isNotEmpty &&
        _maxRoundsValue != null &&
        _roomSizeValue != null) {
      Map<String, String> data = {
        "nickname": _nameController.text,
        "name": _roomNameController.text,
        "occupancy": _maxRoundsValue!,
        "maxRounds": _roomSizeValue!
      };
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              PaintScreen(dataa: data, screenFrom: 'createRoom')));
    } else {
      // Show error message if any field is missing
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Please fill out all fields."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Create Room",
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
            ),
          ),
          SizedBox(height: mq.height * 0.06),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              hintText: "Enter your name",
              nameController: _nameController,
            ),
          ),
          SizedBox(height: mq.height * 0.02),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              hintText: "Enter Room Name",
              nameController: _roomNameController,
            ),
          ),
          SizedBox(height: mq.height * 0.04),
          DropdownButton<String>(
            focusColor: const Color(0xffF5F6FA),
            //value: _maxRoundsValue, // Display the selected value
            items: <String>["2", "5", "10", "15"]
                .map<DropdownMenuItem<String>>(
                  (String value) => DropdownMenuItem(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                )
                .toList(),
            hint: Text(
                _maxRoundsValue != null
                    ? 'Select Max Rounds $_maxRoundsValue'
                    : 'Select Max Rounds',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )),
            onChanged: (String? value) {
              setState(() {
                _maxRoundsValue = value;
              });
            },
          ),
          SizedBox(height: mq.height * 0.03),
          Column(
            children: [
              DropdownButton<String>(
                focusColor: const Color(0xffF5F6FA),
                // value: _roomSizeValue, // Display the selected value
                items: <String>["2", "3", "4", "5", "6", "7", "8"]
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.black),
                        ),
                      ),
                    )
                    .toList(),
                hint: Text(
                    _roomSizeValue != null
                        ? 'Select Room Size : $_roomSizeValue'
                        : 'Select Room Size',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    )),
                onChanged: (String? value) {
                  setState(() {
                    _roomSizeValue = value;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: mq.height * 0.05),
          OutlinedButton(
            onPressed: createRoom,
            style: ButtonStyle(
              fixedSize: WidgetStateProperty.all(const Size(250, 40)),
              shape: WidgetStateProperty.all(
                const ContinuousRectangleBorder(
                  borderRadius: BorderRadiusDirectional.all(
                    Radius.circular(13),
                  ),
                ),
              ),
              backgroundColor: WidgetStateProperty.all(
                const Color.fromARGB(255, 48, 130, 201),
              ),
            ),
            child: const Text(
              "Create",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
