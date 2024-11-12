class SignInModel {
  String? username;
  String? password;

  SignInModel({this.username, this.password});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class SignInResponseModel {
  String? accessToken;
  String? tokenType;

  SignInResponseModel({this.accessToken, this.tokenType});

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) {
    return SignInResponseModel(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
    );
  }
}
