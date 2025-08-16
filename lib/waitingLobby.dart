// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';

class waitingLobbyScreen extends StatefulWidget {
  int occupancy;
  int noOfPlayers;
  String lobbyName;
  final players;
  waitingLobbyScreen({
    Key? key,
    required this.occupancy,
    required this.noOfPlayers,
    required this.lobbyName,
    required this.players,
  }) : super(key: key);

  @override
  State<waitingLobbyScreen> createState() => _waitingLobbyScreenState();
}

class _waitingLobbyScreenState extends State<waitingLobbyScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.03,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            "Waiting for ${widget.occupancy - widget.noOfPlayers} players to join",
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.06,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            readOnly: true,
            onTap: () {
              // copy room code
              Clipboard.setData(ClipboardData(text: widget.lobbyName));
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Copied")));
            },
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: "Tap to copy room code",
              // labelText: "Email",
              // hintText: hintText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
        const Text(
          "Players in lobby ",
          style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        ListView.builder(
            primary: true,
            shrinkWrap: true,
            itemCount: widget.noOfPlayers,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ListTile(
                  leading: Text(
                    "${index + 1}.",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  title: Text(
                    widget.players[index]['nickname'],
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            })
      ],
    ));
  }
}
