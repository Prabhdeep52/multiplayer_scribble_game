import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:scribble_game/paintScreen.dart';
import 'package:scribble_game/widgets/customTextField.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();
  late String? _maxRoundsValue;
  late String? _roomSizeValue;

  void joinRoom() {
    if (_nameController.text.isNotEmpty &&
        _roomNameController.text.isNotEmpty) {
      Map<String, String> data = {
        "nickname": _nameController.text,
        "name": _roomNameController.text
      };

      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              PaintScreen(data: data, screenFrom: 'joinRoom')));
    }
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.24),
            const Text(
              "Join Room",
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
            OutlinedButton(
              onPressed: joinRoom,
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
      ),
    );
  }
}
