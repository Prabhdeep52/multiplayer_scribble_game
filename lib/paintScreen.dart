import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:scribble_game/finalLeaderBoard.dart';
import 'package:scribble_game/home.dart';
import 'package:scribble_game/models/muCustomPainter.dart';
import 'package:scribble_game/models/touchPoint.dart';
import 'package:scribble_game/scoreboard/playerScoreBoard.dart';
import 'package:scribble_game/secrets.dart';
import 'package:scribble_game/waitingLobby.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class PaintScreen extends StatefulWidget {
  final Map<String, String> data;

  final String screenFrom;
  const PaintScreen({super.key, required this.data, required this.screenFrom});

  @override
  State<PaintScreen> createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  late IO.Socket _socket;
  Map dataOfRoom = {};
  List<touchPoints> points = [];
  StrokeCap stroketype = StrokeCap.round;
  Color selectedColor = Colors.black;
  double opacity = 1;
  double strokeWidth = 2;
  List<Widget> textBlankWidget = [];
  ScrollController _scrollController = ScrollController();
  List<Map> messages = [];
  TextEditingController GuessMsgController = TextEditingController();
  int guessedUserCounter = 0;
  int _start = 60;
  late Timer _timer;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map> scoreBoard = [];
  bool isTextInputReadOnly = false;
  int maxPoints = 0;
  bool showFinalLeaderboard = false;
  String winner = "";

  @override
  void initState() {
    super.initState();
    connectt();
    print(widget.data);
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer time) {
      if (_start == 0) {
        _socket.emit('change-turn', dataOfRoom['name']);
        setState(() {
          _timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void renderTextBlank(String text) {
    textBlankWidget.clear();
    for (int i = 0; i < text.length; i++) {
      textBlankWidget.add(const Text(
        "_",
        style: TextStyle(fontSize: 30),
      ));
    }
  }

  // socket connection
  void connectt() {
    // connecting to socket
    _socket = IO.io("http://$ip:3000", <String, dynamic>{
      'transports': ['websocket'],
      // 'autoConnect': false
    });
    _socket.connect();
    _socket.onError((error) {
      print('Socket error: $error');
      // Handle the error here
    });

    // it identifies if the data is comming from createRoom page , if yes , then it emits the signal of create-game and sends the data with itself . this will be listened in the index.js
    if (widget.screenFrom == 'createRoom') {
      _socket.emit('create-game', widget.data);
    } else {
      _socket.emit('join-game', widget.data);
    }

    // listen to socket
    _socket.onConnect((data) {
      print("data");

      // it again hears updateRoom event which is emitted in index.js function and do the work
      _socket.on("updateRoom", (roomData) {
        print(roomData["word"]);
        setState(() {
          renderTextBlank(roomData["word"]);
          dataOfRoom = roomData;
        });

        if (roomData['isJoin'] != true) {
          //start a timer
          startTimer();
        }

        scoreBoard.clear();
        for (int i = 0; i < roomData['players'].length; i++) {
          setState(() {
            scoreBoard.add({
              'username': roomData['players'][i]['nickname'],
              'points': roomData['players'][i]['points'].toString(),
            });
          });
        }
      });

      _socket.on(
          "notCorrectGame",
          (data) => {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                  builder: (context) {
                    return HomePage();
                  },
                ), (route) => false)
              });

      _socket.on("points", (point) {
        if (point['details'] != null) {
          setState(() {
            points.add(touchPoints(
                points: Offset((point['details']['dx']).toDouble(),
                    (point['details']['dy']).toDouble()),
                paint: Paint()
                  ..strokeCap = stroketype
                  ..isAntiAlias = true
                  ..color = selectedColor.withOpacity(opacity)
                  ..strokeWidth = strokeWidth));
          });
        }
      });

      _socket.on("color-change", (colorString) {
        int value = int.parse(colorString, radix: 16);
        Color otherColor = new Color(value);
        setState(() {
          selectedColor = otherColor;
        });
      });

      _socket.on("stroke-width", (value) {
        setState(() {
          strokeWidth = value.toDouble();
        });
      });

      _socket.on('clear-screen', (data) {
        setState(() {
          points.clear();
        });
      });

      _socket.on('close-input', (_) {
        _socket.emit('updateScore', widget.data['name']);
        setState(() {
          isTextInputReadOnly = true;
        });
      });

      _socket.on('msg', (msg) {
        setState(() {
          messages.add(msg);
          guessedUserCounter = msg['guessedUserCtr'];
        });
        if (guessedUserCounter == dataOfRoom['players'].length - 1) {
          _socket.emit('change-turn', dataOfRoom['name']);
        }
        _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 100,
            duration: Duration(milliseconds: 100),
            curve: Curves.easeInOut);
      });

      _socket.on("updateScore", (roomData) {
        scoreBoard.clear();
        for (int i = 0; i < roomData['players'].length; i++) {
          setState(() {
            scoreBoard.add({
              'username': roomData['players'][i]['nickname'],
              'points': roomData['players'][i]['points'].toString(),
            });
          });
        }
      });

      _socket.on('change-turn', (data) {
        String oldWord = dataOfRoom['word'];
        showDialog(
          context: context,
          builder: (context) {
            Future.delayed(Duration(seconds: 2), () {
              setState(() {
                dataOfRoom = data;
                isTextInputReadOnly = false;
                guessedUserCounter = 0;
                points.clear();
                _start = 60;
                renderTextBlank(data['word']);
              });
              Navigator.of(context).pop();
              _timer.cancel();
              startTimer();
            });
            return AlertDialog(
              title: Center(
                child: Text("Word was $oldWord"),
              ),
            );
          },
        );
      });

      _socket.on('show-leaderboard', (roomPlayers) {
        scoreBoard.clear();
        for (int i = 0; i < roomPlayers.length; i++) {
          setState(() {
            scoreBoard.add({
              'username': roomPlayers['players'][i]['nickname'],
              'points': roomPlayers['players'][i]['points'].toString(),
            });
          });

          if (maxPoints < int.parse(scoreBoard[i]['points'])) {
            winner = scoreBoard[i]['username'];
            maxPoints = int.parse(scoreBoard[i]['points']);
          }
        }

        setState(() {
          _timer.cancel();
          showFinalLeaderboard = true;
        });
      });

      _socket.on('user-disconnected', (data) {
        scoreBoard.clear();
        for (int i = 0; i < data['players'].length; i++) {
          setState(() {
            scoreBoard.add({
              'username': data['players'][i]['nickname'],
              'points': data['players'][i]['points'].toString(),
            });
          });
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _socket.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    void selectColor() {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Choose Color'),
                content: SingleChildScrollView(
                    child: BlockPicker(
                        pickerColor: selectedColor,
                        onColorChanged: (color) {
                          String colorString = color.toString();
                          String valueString =
                              colorString.split('(0x')[1].split(')')[0];
                          print(colorString);
                          print(valueString);
                          Map map = {
                            'color': valueString,
                            'roomName': dataOfRoom['name']
                          };
                          _socket.emit('color-change', map);
                        })),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ));
    }

    return Scaffold(
      key: scaffoldKey,
      drawer: PlayerScore(
        scoreBoard,
      ),
      body: dataOfRoom != null
          ? dataOfRoom['isJoin'] != true
              ? !showFinalLeaderboard
                  ? Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: width,
                                height: height * 0.55,
                                child: GestureDetector(
                                  onPanStart: (details) {
                                    print(
                                      details.localPosition.dx,
                                    );
                                    _socket.emit('paint', {
                                      'details': {
                                        'dx': details.localPosition.dx,
                                        'dy': details.localPosition.dy,
                                      },
                                      'roomName': widget.data['name'],
                                    });
                                  },
                                  onPanUpdate: (details) {
                                    print(
                                      details.localPosition.dx,
                                    );
                                    _socket.emit('paint', {
                                      'details': {
                                        'dx': details.localPosition.dx,
                                        'dy': details.localPosition.dy,
                                      },
                                      'roomName': widget.data['name'],
                                    });
                                  },
                                  onPanEnd: (details) {
                                    _socket.emit('paint', {
                                      'details': null,
                                      'roomName': widget.data['name'],
                                    });
                                  },
                                  child: SizedBox.expand(
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      child: RepaintBoundary(
                                        child: CustomPaint(
                                          size: Size.infinite,
                                          painter: MyCustomPainter(
                                              pointsList: points),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        selectColor();
                                      },
                                      icon: Icon(
                                        Icons.color_lens_outlined,
                                        color: selectedColor,
                                      )),
                                  Expanded(
                                      child: Slider(
                                          min: 1.0,
                                          max: 10,
                                          value: strokeWidth,
                                          label: "Stroke width: $strokeWidth",
                                          activeColor: selectedColor,
                                          onChanged: (double value) {
                                            Map map = {
                                              'value': value,
                                              'roomName': dataOfRoom['name']
                                            };
                                            _socket.emit('stroke-width', map);
                                          })),
                                  IconButton(
                                      onPressed: () {
                                        _socket.emit(
                                            'clean-screen', dataOfRoom['name']);
                                      },
                                      icon: Icon(
                                        Icons.layers_outlined,
                                        color: selectedColor,
                                      )),
                                ],
                              ),
                              dataOfRoom['turn']['nickname'] !=
                                      widget.data['nickname']
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: textBlankWidget,
                                    )
                                  : Center(
                                      child: Text(
                                        dataOfRoom['word'],
                                        style: const TextStyle(fontSize: 30),
                                      ),
                                    ),
                              Container(
                                height: height * 0.26,
                                child: ListView.builder(
                                  controller: _scrollController,
                                  shrinkWrap: true,
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    var msg = messages[index].values;
                                    return Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: ListTile(
                                          title: Text(
                                            msg.elementAt(0),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 19,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          subtitle: Text(
                                            msg.elementAt(1),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w300),
                                          )),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        dataOfRoom['turn']['nickname'] !=
                                widget.data['nickname']
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  height: 50,
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 8),
                                  child: TextFormField(
                                    readOnly: isTextInputReadOnly,
                                    controller: GuessMsgController,
                                    onFieldSubmitted: (value) {
                                      print(value.trim() + "  hugh");
                                      if (value.trim().isNotEmpty) {
                                        Map map = {
                                          'username': widget.data['nickname'],
                                          'msg': value.trim(),
                                          'word': dataOfRoom['word'],
                                          'roomName': widget.data['name'],
                                          'guessedUserCtr': guessedUserCounter,
                                          'totalTime': 60,
                                          'timeTaken': 60 - _start,
                                        };
                                        _socket.emit('msg', map);
                                        GuessMsgController.clear();
                                      }
                                    },
                                    keyboardType: TextInputType.emailAddress,
                                    autocorrect: false,
                                    textInputAction: TextInputAction.done,
                                    decoration: InputDecoration(
                                      // labelText: "Email",
                                      hintText: "Your Guess",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(9),
                                      ),
                                    ),
                                  ),
                                ))
                            : Container(),
                        SafeArea(
                            child: IconButton(
                                onPressed: () =>
                                    scaffoldKey.currentState!.openDrawer(),
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.black,
                                )))
                      ],
                    )
                  : FinalLeaderBoard(scoreBoard, winner)
              : waitingLobbyScreen(
                  noOfPlayers: dataOfRoom['players'].length,
                  occupancy: dataOfRoom['occupancy'],
                  lobbyName: dataOfRoom['name'],
                  players: dataOfRoom['players'],
                )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 30),
        child: FloatingActionButton(
          onPressed: () {},
          elevation: 7,
          backgroundColor: Colors.white,
          child: Text(
            "$_start",
            style: TextStyle(color: Colors.black, fontSize: 22),
          ),
        ),
      ),
    );
  }
}
