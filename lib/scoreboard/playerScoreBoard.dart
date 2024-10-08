import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class PlayerScore extends StatelessWidget {
  final List<Map> userData;
  const PlayerScore(this.userData, {super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Expanded(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ),
            const Text("Scoreboard",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: ListView.builder(
                    itemCount: userData.length,
                    itemBuilder: (context, index) {
                      var data = userData[index].values;
                      return ListTile(
                        title: Text(
                          data.elementAt(0),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 132, 102, 102),
                              fontSize: 22),
                        ),
                        trailing: Text(
                          data.elementAt(1),
                          style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    })),
          ],
        ),
      ),
    );
  }
}
