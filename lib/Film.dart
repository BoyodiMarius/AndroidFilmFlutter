import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'Database.dart';
import 'DetailsFilms.dart';
import 'Favoris.dart';
import 'Profil.dart';
import 'User.dart';
import 'creationCompte.dart';
import 'main.dart';


class Film {
  int id;
  String titre;
  String resume;
  String acteurs;
  String categories;
  String photo;
  String duree;
  String dateSortie;

  Film(
      {this.id, this.titre, this.resume, this.acteurs, this.categories, this.photo, this.duree, this.dateSortie});

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      id: json['id'],
      titre: json['title'],
      resume: json['synopsis'],
      acteurs: json['actors'],
      categories: json['category'],
      photo: json['posters']['medium'],
      duree: json['length'],
      dateSortie: json['released_on'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
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

class HttpService{

  Future<List<Film>> getFilms( String annee) async {
    String films = "https://cinema.apidae-tourisme.com/api/v001/315395/seances.json?dateDebut=01-01-"+annee+"&dateFin=31-12-"+annee;

    var reponse = await http.get(films);

    if (reponse.statusCode == 200) {
      var jsonData = json.decode(reponse.body);
      List<dynamic> data = jsonData["theater_movies"];
      var jsonDataTr = data.map((film) => new Film.fromJson(film)).toList();
      return jsonDataTr;
    } else {
      throw "Failed to load films";
    }
  }
}

class MyFilmPage extends StatefulWidget {
  final User user;
  MyFilmPage({Key key, @required this.user}) : super(key: key);
  @override
  _MyFilmPageState createState() => _MyFilmPageState();
}

class _MyFilmPageState extends State<MyFilmPage> {
  final HttpService httpService = HttpService();
  String annee = DateTime.now().year.toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:   Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Films de "),
            new DropdownButton<String>(
                items: <String>[ '2020', '2019', '2018', '2017', '2016'].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                hint:Text(annee),
                onChanged:(String val){
                  annee= val;
                  setState(() {
                    annee= val;
                  });
                }
            ),

          ],
        ),
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
        future: httpService.getFilms(annee),
        builder: (BuildContext context, AsyncSnapshot<List<Film>> snapshot) {
          if (snapshot.hasData) {
            return GridView.count(
                  crossAxisCount: 1,
                  children: List.generate(snapshot.data.length, (index) {
                    return Center(
                      child: Column(
                        children: <Widget>[
                          Image.network(
                            'https://cinema.apidae-tourisme.com/'+snapshot.data[index].photo,
                          ),
                          Text(
                            snapshot.data[index].titre,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          RaisedButton(
                            onPressed: (){
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                        id: snapshot.data[index].id,
                                        titre: snapshot.data[index].titre,
                                        resume: snapshot.data[index].resume,
                                        acteurs: snapshot.data[index].acteurs,
                                        categories: snapshot.data[index].categories,
                                        photo: snapshot.data[index].photo,
                                        duree: snapshot.data[index].duree,
                                        dateSortie: snapshot.data[index].dateSortie,
                                        user: this.widget.user,)
                                  )
                              );
                            },
                            color: Colors.blueGrey,
                            textColor: Colors.white,
                            child: Text("Détails"),
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 20,
                            thickness: 5,
                            indent: 20,
                            endIndent: 0,
                          ),
                        ],
                      )
                    );
                  }),
                );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );

  }
}



