import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'Database.dart';
import 'Film.dart';
import 'User.dart';

class users {
  static Future<void> insertUser(User user) async {
    final Database db = await MyDatabase.database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<User>> usersList() async {
    // Get a reference to the database.
    final Database db = await MyDatabase.database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('users');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
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
}

class UsersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: FutureBuilder(
        future: users.usersList(),
        builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){
                return ListTile(
                  title: Text(snapshot.data[index].lastName),
                  subtitle: Text(snapshot.data[index].firstName),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}


class CreateComptePage extends StatefulWidget {
  CreateComptePage({Key key}) : super(key: key);
  @override
  _CreateComptePageState createState() => _CreateComptePageState();
}

class _CreateComptePageState extends State<CreateComptePage> {
  int res = 0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String Reponse = "";
  final firstNameC = TextEditingController();
  final lastNameC = TextEditingController();
  final userNameC = TextEditingController();
  final passwordC = TextEditingController();
  final passwordConfirmC = TextEditingController();

  bool vuePwd,vuePwdConfirm;

  @override void initState() {
    super.initState();
    vuePwd = true;
    vuePwdConfirm = true;
    annuler();
  }

  void annuler() {
    firstNameC.clear();
    lastNameC.clear();
    userNameC.clear();
    passwordC.clear();
    passwordConfirmC.clear();
    vuePwd = true;
    vuePwdConfirm = true;
  }


  @override
  Widget build(BuildContext context) {
    _displaySnackBar(BuildContext context, String message) {
      final snackBar = SnackBar(content: Text(message));
      _scaffoldKey.currentState.showSnackBar(snackBar);
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
    vuePassWordConfirmText(){
      setState(() {
        if(vuePwdConfirm==true){
          vuePwdConfirm = false;
        } else  {
          vuePwdConfirm = true;
        }
      });
    }

    void _creerCompte(){
      var donnee = User(
        firstName: firstNameC.text,
        lastName: lastNameC.text,
        userMail: userNameC.text,
        password: passwordC.text,
        photo: "conclusion.JPG",
      );
      String p1= passwordC.text;
      String p2= passwordConfirmC.text;
      print("resultttttttttttttt  "+p1.compareTo(p2).toString());
      if(p1.trim().length==0 || p2.trim().length==0){
        _displaySnackBar(context, "Mot de passe non Conforme");
      } else {
        if(p1.compareTo(p2) == 0){
          users.insertUser(donnee);
          annuler();
          _displaySnackBar(context, "Compte créer");
        } else{
          _displaySnackBar(context, "Mot de passe non Conforme");
        }
      }

    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Création de compte"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container( width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Nom',
                    ),
                    controller: lastNameC,
                  )
              ),
              Container( width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Prénom(s)',
                    ),
                    controller: firstNameC,
                  )
              ),
              Container( width: 300,
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Adresse Mail',

                    ),
                    validator: (String value) {
                      return value.contains('@') ? 'Do not use the @ char.' : null;
                    },
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
                          obscureText: vuePwd,
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

                        ),
                      )
                    ],
                  )
              ),
              Container(
                  width: 300,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Confirmer mot de passe ',
                          ),
                          controller: passwordConfirmC,
                          autofocus: false,
                          obscureText: vuePwdConfirm,
                        ),
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            size: 20,
                          ),
                          onPressed: (){
                            vuePassWordConfirmText();
                          },

                        ) ,
                      )
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
                        _creerCompte();
                      },
                      color: Colors.green,
                      textColor: Colors.white,
                      child: Text("Créer"),
                    ),
                    RaisedButton(
                      onPressed: (){
                        annuler();
                      },
                      color: Colors.brown,
                      textColor: Colors.white,
                      child: Text("Annuler"),
                    )
                  ],
                ) ,
              ),

            ],
          ),
        )
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}