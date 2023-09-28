import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:scribble_game/paintScreen.dart';
import 'package:scribble_game/widgets/customTextField.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();
  late String? _maxRoundsValue;
  late String? _roomSizeValue;

  void createRoom() {
    // this sends the data in form of a map to the paint screen .
    // it uses screenFrom to identify the page from where the data is comming , in this case data is comming from createRoom page
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
              PaintScreen(data: data, screenFrom: 'createRoom')));
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.06),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              hintText: "Enter your name",
              nameController: _nameController,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomTextField(
              hintText: "Enter Room Name",
              nameController: _roomNameController,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          DropdownButton<String>(
            focusColor: const Color(0xffF5F6FA),
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
            hint: const Text('Select Max Rounds',
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          DropdownButton<String>(
            focusColor: const Color(0xffF5F6FA),
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
            hint: const Text('Select Room Size',
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
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          OutlinedButton(
            onPressed: createRoom,
            style: ButtonStyle(
              fixedSize: MaterialStateProperty.all(const Size(250, 40)),
              shape: MaterialStateProperty.all(
                const ContinuousRectangleBorder(
                  borderRadius: BorderRadiusDirectional.all(
                    Radius.circular(13),
                  ),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
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
