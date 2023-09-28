import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:scribble_game/models/muCustomPainter.dart';
import 'package:scribble_game/models/touchPoint.dart';
import 'package:scribble_game/secrets.dart';
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

  @override
  void initState() {
    super.initState();
    connectt();

    print(widget.data);
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
        }
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

      _socket.on('msg', (msg) {
        setState(() {
          messages.add(msg);
        });
        _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 100,
            duration: Duration(milliseconds: 100),
            curve: Curves.easeInOut);
      });
    });
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
        body: Stack(
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
                    _socket.emit('paint', {
                      'details': {
                        'dx': details.localPosition.dx,
                        'dy': details.localPosition.dy,
                      },
                      'roomName': widget.data['name'],
                    });
                  },
                  onPanUpdate: (details) {
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
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      child: RepaintBoundary(
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: MyCustomPainter(pointsList: points),
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
                        _socket.emit('clean-screen', dataOfRoom['name']);
                      },
                      icon: Icon(
                        Icons.layers_outlined,
                        color: selectedColor,
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: textBlankWidget,
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
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50,
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 8),
              child: TextFormField(
                controller: GuessMsgController,
                onFieldSubmitted: (value) {
                  print(value.trim() + "  hugh");
                  if (value.trim().isNotEmpty) {
                    Map map = {
                      'username': widget.data['nickname'],
                      'msg': value.trim(),
                      'word': dataOfRoom['word'],
                      'roomName': widget.data['name'],
                      // 'guessedUserCtr': guessedUserCtr,
                      // 'totalTime': 60,
                      // 'timeTaken': 60 - _start,
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
      ],
    ));
  }
}
