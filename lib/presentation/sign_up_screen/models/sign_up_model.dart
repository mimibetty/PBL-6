class SignUpModel {
  String? username;
  String? email;
  String? password;

  SignUpModel({this.username, this.email, this.password});

  SignUpModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }
}
