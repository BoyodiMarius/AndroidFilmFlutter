import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'Database.dart';
import 'Film.dart';
import 'Profil.dart';
import 'User.dart';
import 'main.dart';

class MyFavoris {
  int id;
  int idFilm;
  int idUser;
  String titre;
  String resume;
  String acteurs;
  String categories;
  String photo;
  String duree;
  String dateSortie;

  MyFavoris(
      {this.id,this.idFilm, this.idUser, this.titre, this.resume, this.acteurs, this.categories, this.photo, this.duree, this.dateSortie});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idFilm': idFilm,
      'idUser': idUser,
      'titre': titre,
      'resume': resume,
      'acteurs': acteurs,
      'categories': categories,
      'photo': photo,
      'duree': duree,
      'dateSortie': dateSortie,
    };
  }
}

class favoris {
  static Future<void> insertFavoris(Film film) async {
    final Database db = await MyDatabase.database;
    await db.insert(
      'favoris',
      film.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> deleteFavoris(int id) async {
    // Get a reference to the database.
    final Database db = await MyDatabase.database;

    // Remove the Dog from the Database.
    await db.delete(
      'favoris',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  static Future<List<MyFavoris>> favorisListPar(int idUser) async {
    // Get a reference to the database.
    final Database db = await MyDatabase.database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('favoris', where: "idUser=?", whereArgs: [idUser]);

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return MyFavoris(
          id: maps[i]['id'],
          idFilm: maps[i]['idFilm'] ,
          idUser: maps[i]['idUser'] ,
          titre: maps[i]['titre'],
          resume: maps[i]['resume'],
          acteurs: maps[i]['acteurs'],
          categories: maps[i]['categories'],
          photo: maps[i]['photo'],
          duree: maps[i]['duree'],
          dateSortie: maps[i]['dateSortie']
      );
    });
  }

  static Future<List<MyFavoris>> favorisList() async {
    // Get a reference to the database.
    final Database db = await MyDatabase.database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('favoris');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return MyFavoris(
          id: maps[i]['id'],
          idFilm: maps[i]['idFilm'] ,
          titre: maps[i]['titre'],
          resume: maps[i]['resume'],
          acteurs: maps[i]['acteurs'],
          categories: maps[i]['categories'],
          photo: maps[i]['photo'],
          duree: maps[i]['duree'],
          dateSortie: maps[i]['dateSortie']
      );
    });
  }
}

class MyFavoritePage extends StatefulWidget {
  final User user;
  MyFavoritePage({Key key, @required this.user}) : super(key: key);
  @override
  _MyFavoritePageState createState() => _MyFavoritePageState();
}

class _MyFavoritePageState extends State<MyFavoritePage> {

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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyFavoritePage(user: this.widget.user,),
                    )
                );
              },
            ),
          ],
        );
      },
    );
  }
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    _displaySnackBar(BuildContext context) {
      final snackBar = SnackBar(content: Text('Supprimé'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title:   Text("Favoris"),
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
      body: FutureBuilder(
        future: favoris.favorisListPar(widget.user.id),
        builder: (BuildContext context, AsyncSnapshot<List<MyFavoris>> snapshot) {
          if (snapshot.hasData) {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(snapshot.data.length, (index) {
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Image.network(
                            'https://cinema.apidae-tourisme.com/'+snapshot.data[index].photo,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "TITRE : ",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              Text(
                                snapshot.data[index].titre,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black87,
                                ),
                              )

                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "DURÉE : ",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.blueGrey,
                                ),

                              ),
                              Text(
                                snapshot.data[index].duree,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black87,
                                ),
                              )
                            ],
                          ) ,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "DATE DE SORTIE : ",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.blueGrey,
                                ),

                              ),
                              Text(
                                snapshot.data[index].dateSortie,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black87,
                                ),
                              )
                            ],
                          ) ,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "CATEGORIE(S) : ",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.blueGrey,
                                ),

                              ),
                            ],
                          ) ,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  snapshot.data[index].categories,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                              )
                            ],
                          ) ,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "ACTEURS : ",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.blueGrey,
                                ),

                              )
                            ],
                          ) ,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  snapshot.data[index].acteurs,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                              )
                            ],
                          ) ,
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "RÉSUMER : ",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.blueGrey,
                                ),

                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  snapshot.data[index].resume,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),

                            ],
                          ) ,
                        ),
                        Container(
                          width: 300,
                          padding: EdgeInsets.all(15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: (){
                                  favoris.deleteFavoris(snapshot.data[index].id);
                                  _showMyDialog("Le film "+ snapshot.data[index].titre+"  est supprimé de vos favoris");

                                },
                                color: Colors.brown,
                                textColor: Colors.white,
                                child: Text("Supprimer"),
                              )
                            ],
                          ) ,
                        ),
                        const Divider(
                          color: Colors.black,
                          height: 20,
                          thickness: 5,
                          indent: 20,
                          endIndent: 0,
                        )
                      ],
                    );
                  },
                  )
                ),
              )
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );

  }
}