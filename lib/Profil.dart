import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resto_app/main.dart';

import 'Database.dart';
import 'Favoris.dart';
import 'Film.dart';
import 'User.dart';


class MyProfilPage extends StatefulWidget {
  User user;
  MyProfilPage({Key key, @required this.user}) : super(key: key);
  @override
  _MyProfilPageState createState() => _MyProfilPageState();
}

class _MyProfilPageState extends State<MyProfilPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  File _image;
  int res = 0;
  TextEditingController firstNameC;
  TextEditingController lastNameC;
  TextEditingController userNameC;
  TextEditingController passwordC;
  TextEditingController passwordConfirmC;

  bool firstNameB,lastNameB,userNameB, passwordB,passwordConfirmB, vuePwd,vuePwdConfirm;

@override void initState() {
  super.initState();
  firstNameC = new TextEditingController(text: this.widget.user.firstName);
  lastNameC = new TextEditingController(text: this.widget.user.lastName);
  userNameC = new TextEditingController(text: this.widget.user.userMail);
  passwordC = new TextEditingController(text: '');
  passwordConfirmC = new TextEditingController(text: '');
  firstNameB = false;
  lastNameB = false;
  userNameB = false;
  passwordB = false;
  passwordConfirmB = false;
  vuePwd = false;
  vuePwdConfirm = false;
}


  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog(String message) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('SUCCES', style: TextStyle(
                        fontSize: 32,
                        color: Colors.green,
                    ) ,
            ),
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

    Future getImage() async{
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
      });
    }

    Future UpdatePhoto(User user, String newPhoto) async{
      setState(() {
        res = 0;
      });
      user.photo = newPhoto;
      final db = await MyDatabase.database;
      await db.update(
        'users',
        user.toMap(),
        where: "id = ?",
        whereArgs: [user.id],
      );
      setState(() {
        this.widget.user = user;
        res = 1;
      });
    }

    Future UploadPic(BuildContext context) async{
      String filename = basename(_image.path);
      StorageReference firebaseStorageRef= FirebaseStorage.instance.ref().child(filename);
      StorageUploadTask uploadTask= firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      UpdatePhoto(this.widget.user, filename);
    }

    _displaySnackBar(BuildContext context, String message) {
      final snackBar = SnackBar(content: Text(message));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }



    Function _buttonLastName(bool etat) {
      if (etat) {
        return null;
      } else {
        return () {
          // do anything else you may want to here
          UploadPic(context);
          if(res==1){
            _displaySnackBar(context,"Photo modifié");
            setState(() {
              res=0;
            });
          }
        };
      }
    }

    disableLastname(){
      setState(() {
        lastNameB=true;
      });
    }

    Future UpdateLastname(User user, String newLastname) async{
      user.lastName = newLastname;
      final db = await MyDatabase.database;
      await db.update(
        'users',
        user.toMap(),
        where: "id = ?",
        whereArgs: [user.id],
      );
      _displaySnackBar(context, "Nom modifié");
      setState(() {
        this.widget.user = user;
        lastNameB=false;
      });
    }


    disableFirstname(){
      setState(() {
        firstNameB=true;
      });
    }

    Future UpdateFirstname(User user, String newFirstname) async{
      user.firstName = newFirstname;
      final db = await MyDatabase.database;
      await db.update(
        'users',
        user.toMap(),
        where: "id = ?",
        whereArgs: [user.id],
      );
      _displaySnackBar(context, "Prénom modifié");
      setState(() {
        this.widget.user = user;
        firstNameB=false;
      });
    }

    disableUsername(){
      setState(() {
        userNameB=true;
      });
    }

    Future UpdateUsername(User user, String newUsername) async{
      user.userMail = newUsername;
      final db = await MyDatabase.database;
      await db.update(
        'users',
        user.toMap(),
        where: "id = ?",
        whereArgs: [user.id],
      );
      _displaySnackBar(context, "Adresse mail modifié");
      setState(() {
        this.widget.user = user;
        userNameB=false;
      });
    }

    disablePassWord(){
      setState(() {
        passwordB=true;
        passwordConfirmB=true;
      });
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

    Future UpdatePassWord(User user, String newPassWord, String newPassWordConfirm) async{
      user.password = newPassWord.trim();
      if(newPassWord.trim().length==0 || newPassWordConfirm.trim().length==0){
        _displaySnackBar(context, "Mot de passe non comforme");
      } else {
        if(newPassWord.compareTo(newPassWordConfirm)==0){
          final db = await MyDatabase.database;
          await db.update(
            'users',
            user.toMap(),
            where: "id = ?",
            whereArgs: [user.id],
          );
          _displaySnackBar(context, "Mot de passe  modifié");
          setState(() {
            this.widget.user = user;
            passwordB=false;
            passwordConfirmB=false;
            vuePwd = true;
            vuePwdConfirm= true;
            passwordConfirmC.clear();
            passwordC.clear();
          });
        } else {
          _displaySnackBar(context, "Mot de passe non comforme");
        }
      }


    }


    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Profil"),
      ),
      drawer: new Drawer(
        child: new ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: new Text(widget.user.firstName + " "+widget.user.lastName),
              accountEmail: new Text(widget.user.userMail),
              currentAccountPicture:CircleAvatar(
                radius: 30.0,
                backgroundImage:
                NetworkImage("https://firebasestorage.googleapis.com/v0/b/actumovies-779e7.appspot.com/o/"+widget.user.photo+"?alt=media&token=8135a577-1bdc-42ec-8066-f081e4801b42",
                ),
                backgroundColor: Colors.transparent,
              ),
            ),
            new ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap:() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyFilmPage(user: this.widget.user,),
                    )
                );
              },
            ),
            new ListTile(
              leading: Icon(Icons.thumb_up),
              title: Text('Favoris'),
              onTap:() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyFavoritePage(user: this.widget.user,),
                    )
                );
              },
            ),
            new ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil'),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyProfilPage(user: this.widget.user,),
                    )
                );
              },
            ),
            new ListTile(
              leading: Icon(Icons.power_settings_new),
              title: Text('Déconnecter'),
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyAcceuilPage(),
                    )
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Color(0xff476cfb),
                        child: ClipOval(
                          child: SizedBox(
                            width: 180.0,
                            height: 180.0,
                            child:(_image!=null)?Image.file(_image, fit: BoxFit.fill,)
                                : Image.network(
                              "https://firebasestorage.googleapis.com/v0/b/actumovies-779e7.appspot.com/o/"+widget.user.photo+"?alt=media&token=8135a577-1bdc-42ec-8066-f081e4801b42",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 60.0),
                        child: Column(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                size: 30,
                              ),
                              onPressed: (){
                                getImage();
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.update,
                                size: 30,
                              ),
                              onPressed: (){
                                UploadPic(context);
                                if(res==1){
                                  _displaySnackBar(context,"Photo modifié");
                                  setState(() {
                                    res=0;
                                  });
                                }
                              },
                            ),
                          ],
                        )
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child:  Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Nom',
                        ),
                        enabled: lastNameB,
                        controller: lastNameC,
                      ) ,
                    ),
                    Expanded(
                      child:  Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.remove_red_eye,
                              size: 20,
                            ),
                            onPressed: (){
                            },

                          ),
                          IconButton(
                            icon: Icon(
                              Icons.loop,
                              size: 20,
                            ),
                            onPressed: (){
                              disableLastname();
                            },

                          ),
                          IconButton(
                            icon: Icon(
                              Icons.assignment_turned_in,
                              size: 20,
                            ),
                            onPressed: (){
                              UpdateLastname(this.widget.user,lastNameC.text);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child:  Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Prénom(s)',
                        ),
                        enabled: firstNameB,
                        controller: firstNameC,
                      ) ,
                    ),
                    Expanded(
                      child:  Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.remove_red_eye,
                              size: 20,
                            ),
                            onPressed: (){
                            },

                          ),
                          IconButton(
                            icon: Icon(
                              Icons.loop,
                              size: 20,
                            ),
                            onPressed: (){
                              disableFirstname();
                            },

                          ),
                          IconButton(
                            icon: Icon(
                              Icons.assignment_turned_in,
                              size: 20,
                            ),
                            onPressed: (){
                              UpdateFirstname(this.widget.user,firstNameC.text);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child:  Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Adresse Mail',
                        ),
                        enabled: userNameB,
                        controller: userNameC,
                      ) ,
                    ),
                    Expanded(
                      child:  Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.remove_red_eye,
                              size: 20,
                            ),
                            onPressed: (){
                            },

                          ),
                          IconButton(
                            icon: Icon(
                              Icons.loop,
                              size: 20,
                            ),
                            onPressed: (){
                              disableUsername();
                            },

                          ),
                          IconButton(
                            icon: Icon(
                              Icons.assignment_turned_in,
                              size: 20,
                            ),
                            onPressed: (){
                              UpdateUsername(this.widget.user,userNameC.text);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child:  Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                        ),
                        enabled: passwordB,
                        controller: passwordC,
                        autofocus: false,
                        obscureText: vuePwd,
                      ) ,
                    ),
                    Expanded(
                      child:  Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.remove_red_eye,
                              size: 20,
                            ),
                            onPressed: (){
                              vuePassWordText();
                            },

                          ),
                          IconButton(
                            icon: Icon(
                              Icons.loop,
                              size: 20,
                            ),
                            onPressed: (){
                              disablePassWord();
                            },

                          ),
                          IconButton(
                            icon: Icon(
                              Icons.assignment_turned_in,
                              size: 20,
                            ),
                            onPressed: (){
                              UpdatePassWord(this.widget.user,passwordC.text,passwordConfirmC.text);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),Padding(
                padding: EdgeInsets.all(8.0),
                child:  Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Confirmer mot de passe',
                        ),
                        enabled: passwordConfirmB,
                        controller: passwordConfirmC,
                        autofocus: false,
                        obscureText: vuePwdConfirm,
                      ) ,
                    ),
                    Expanded(
                      child:  Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.remove_red_eye,
                              size: 20,
                            ),
                            onPressed: (){
                              vuePassWordConfirmText();
                            },

                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  String basename(String path) {
    var result = path.split("/");
    int index = result.length;
    return result[index-1].toString();
  }

}