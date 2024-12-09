class LoginModel {
  int? userId;
  String? username;
  String? emailId;

  LoginModel({this.userId, this.username, this.emailId});

  LoginModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    username = json['username'];
    emailId = json['email_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['email_id'] = this.emailId;
    return data;
  }
}