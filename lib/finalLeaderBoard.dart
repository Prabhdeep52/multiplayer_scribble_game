import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class FinalLeaderBoard extends StatelessWidget {
  final scoreBoard;
  final String winner;
  FinalLeaderBoard(this.scoreBoard, this.winner);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(8),
        height: double.maxFinite,
        child: Column(
          children: [
            Text(
              "$winner has won the game",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            ListView.builder(
                primary: true,
                shrinkWrap: true,
                itemCount: scoreBoard.length,
                itemBuilder: (context, index) {
                  var data = scoreBoard[index].values;
                  return ListTile(
                    title: Text(
                      data.elementAt(0),
                      style: const TextStyle(color: Colors.black, fontSize: 23),
                    ),
                    trailing: Text(
                      data.elementAt(1),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
