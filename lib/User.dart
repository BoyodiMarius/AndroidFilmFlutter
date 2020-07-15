class User {
  int id;
  String firstName;
  String lastName;
  String userMail;
  String password;
  String photo;

  User({this.id, this.firstName, this.lastName, this.userMail, this.password, this.photo});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ,
      firstName: json['firstName'] ,
      lastName: json['lastName'] ,
      userMail: json['userMail'] ,
      password: json['password'] ,
      photo: json['photo'] ,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'userMail': userMail,
      'password': password,
      'photo': photo,
    };
  }
}
