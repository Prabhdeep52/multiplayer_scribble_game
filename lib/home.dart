import 'package:flutter/material.dart';
import './CreateRoomScreen.dart';
import './JoinRoomScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Create or Join a Room ",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: mq.height * 0.04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return const CreateRoomScreen();
                      },
                    ));
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(const Size(170, 40)),
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
                SizedBox(
                  width: mq.width * 0.04,
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return const JoinRoomScreen();
                      },
                    ));
                  },
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(const Size(170, 40)),
                    shape: MaterialStateProperty.all(
                      const ContinuousRectangleBorder(
                        borderRadius: BorderRadiusDirectional.all(
                          Radius.circular(13),
                        ),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 215, 214, 214),
                    ),
                  ),
                  child: const Text(
                    "Join",
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            )
          ]),
    );
  }
}
