import 'package:flutter/material.dart';
import 'package:resto_app/Database.dart';
import 'package:resto_app/User.dart';
import 'package:sqflite/sqflite.dart';
import 'package:video_player/video_player.dart';

import 'Film.dart';
import 'creationCompte.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: MyAcceuilPage()

    );
  }
}

class MyAcceuilPage extends StatefulWidget {
  MyAcceuilPage({Key key}) : super(key: key);
  @override
  _MyAcceuilPageState createState() => _MyAcceuilPageState();
}

class _MyAcceuilPageState extends State<MyAcceuilPage> {
  String Reponse="";
  User userConnect = null;
  final userNameC = TextEditingController();
  final passwordC = TextEditingController();
  bool vuePwd;
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override void initState() {
    _controller = VideoPlayerController.network(
      'https://firebasestorage.googleapis.com/v0/b/actumovies-779e7.appspot.com/o/thriller.mp4?alt=media&token=8135a577-1bdc-42ec-8066-f081e4801b42',
    );

    _initializeVideoPlayerFuture = _controller.initialize();
    super.initState();
    vuePwd = true;
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    Future<void> _showMyDialog(String message) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('ERREUR', style: TextStyle(
              fontSize: 32,
              color: Colors.red,
            ) ,),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(message),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Future<List<User>> usersList() async {
      // Get a reference to the database.
      final Database db = await MyDatabase.database;

      final List<Map<String, dynamic>> maps = await db.query('users');

      return List.generate(maps.length, (i) {
        return User(
          id: maps[i]['id'],
          lastName: maps[i]['lastName'],
          firstName: maps[i]['firstName'],
          userMail: maps[i]['userMail'],
          password: maps[i]['password'],
          photo: maps[i]['photo'],
        );
      });
    }

    Future _connecter() async{
      final Database db = await MyDatabase.database;

      // Query the table for all The Dogs.
      final List<Map<String, dynamic>> maps = await db.query('users');
      List<User> list = List.generate(maps.length, (i) {
        return User(
          id: maps[i]['id'],
          lastName: maps[i]['lastName'],
          firstName: maps[i]['firstName'],
          userMail: maps[i]['userMail'],
          password: maps[i]['password'],
          photo: maps[i]['photo'],
        );
      });

      if(list.length !=0){
        for(int i = 0; i<list.length;i++){
         String userDb = list[i].userMail;
         String mdpDb = list[i].password;
         String userSa = userNameC.text;
         String mdpSa = passwordC.text;
          if(userDb.compareTo(userSa) ==0 && mdpDb.compareTo(mdpSa) ==0  ){
            userConnect = list[i];
          }
        }
      } else {
        setState(() {
          userConnect= null;
          Reponse = "Mot de passe ou Adresse mail incorrect";

        });
        _showMyDialog(Reponse);
      }

      if(userConnect!=null){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyFilmPage(user: userConnect),
            )
        );
      } else if(userConnect==null) {
        setState(() {
          userConnect= null;
          Reponse = "Mot de passe ou Adresse mail incorrect";
        });
        _showMyDialog(Reponse);
      }
    }
    vuePassWordText(){
      setState(() {
        if(vuePwd==true){
          vuePwd = false;
        } else  {
          vuePwd = true;
        }
      });
    }



    return Scaffold(
      appBar: AppBar(
        title: Text("Actu Movies"),
      ),
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the VideoPlayer.
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        // Use the VideoPlayer widget to display the video.
                        child: VideoPlayer(_controller),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                size: 30,
                              ),
                              onPressed: () {
                                // Wrap the play or pause in a call to `setState`. This ensures the
                                // correct icon is shown.
                                setState(() {
                                  // If the video is playing, pause it.
                                  if (_controller.value.isPlaying) {
                                    _controller.pause();
                                  } else {
                                    // If the video is paused, play it.
                                    _controller.play();
                                  }
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                 Icons.replay,
                                size: 30,
                              ),
                              onPressed: () {
                                // Wrap the play or pause in a call to `setState`. This ensures the
                                // correct icon is shown.
                                setState(() {
                                  // If the video is playing, pause it.
                                  _controller.pause();
                                  _controller = null;
                                  _controller = VideoPlayerController.network(
                                    'https://firebasestorage.googleapis.com/v0/b/actumovies-779e7.appspot.com/o/thriller.mp4?alt=media&token=8135a577-1bdc-42ec-8066-f081e4801b42',
                                  );
                                  _controller.initialize();
                                });
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child:  Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container( width: 300,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Adresse mail',
                                  ),
                                  controller: userNameC,
                                )
                            ),
                            Container(
                                width: 300,
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: TextField(
                                        decoration: InputDecoration(
                                          hintText: 'Mot de Passe ',
                                        ),
                                        controller: passwordC,
                                        autofocus: false,
                                        obscureText: true,
                                      ),
                                    ),
                                    Expanded(
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.remove_red_eye,
                                          size: 20,
                                        ),
                                        onPressed: (){
                                          vuePassWordText();
                                        },

                                      ) ,
                                    ),
                                  ],
                                )
                            ),
                            Container(
                              width: 300,
                              padding: EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed: (){
                                      _connecter();
                                    },
                                    color: Colors.green,
                                    textColor: Colors.white,
                                    child: Text("Connecter"),
                                  ),
                                  RaisedButton(
                                    onPressed: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CreateComptePage(),
                                          )
                                      );
                                    },
                                    color: Colors.blueGrey,
                                    textColor: Colors.white,
                                    child: Text("Nouveau Compte"),
                                  )
                                ],
                              ) ,
                            ),


                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),


      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
