import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';


import 'Database.dart';
import 'Favoris.dart';
import 'Film.dart';
import 'User.dart';

class DetailPage extends StatefulWidget {

  final int id;
  final String titre;
  final String resume;
  final String acteurs;
  final String categories;
  final String photo;
  final String duree;
  final String dateSortie;
  final User user;
  DetailPage({
    Key key,
    @required this.id,
    @required this.titre,
    @required this.resume,
    @required this.acteurs,
    @required this.categories,
    @required this.photo,
    @required this.duree,
    @required this.dateSortie,
    @required this.user,
  }) : super(key: key);
  @override
  _DetailPageState createState() => _DetailPageState();
}

class favorisInsert {
  static Future<void> insertFavoris(MyFavoris favoris) async {
    final Database db = await MyDatabase.database;
    await db.insert(
      'favoris',
      favoris.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

class _DetailPageState extends State<DetailPage> {


  final _scaffoldKey = GlobalKey<ScaffoldState>();
  void _ajouterFavoris(){
    var donnee = MyFavoris(
      id: widget.id,
      idFilm: widget.id,
      idUser: widget.user.id,
      titre: widget.titre,
      resume: widget.resume,
      acteurs: widget.acteurs,
      categories: widget.categories,
      photo: widget.photo,
      duree: widget.duree,
      dateSortie: widget.dateSortie
    );

    favorisInsert.insertFavoris(donnee);
  }

  @override
  Widget build(BuildContext context) {
    _displaySnackBar(BuildContext context) {
      final snackBar = SnackBar(content: Text('Ajouté'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Details"),
      ),
      body:  Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Image.network(
                  'https://cinema.apidae-tourisme.com/'+widget.photo,
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
                      widget.titre,
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
                      widget.duree,
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
                      widget.dateSortie,
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
                        widget.categories,
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
                        widget.acteurs,
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
                        widget.resume,
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
                        _ajouterFavoris();
                        _displaySnackBar(context);
                      },
                      color: Colors.deepOrangeAccent,
                      textColor: Colors.white,
                      child: Text("Ajouter aux Favoris"),
                    ),
                    RaisedButton(
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyFilmPage(user: this.widget.user,),
                            )
                        );
                      },
                      color: Colors.grey,
                      textColor: Colors.white,
                      child: Text("Retour"),
                    )
                  ],
                ) ,
              )
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}