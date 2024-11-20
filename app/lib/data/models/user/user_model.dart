class UserModel {
  String? sId;
  String? fullName;
  String? email;
  String? password;
  String? phoneNumber;
  String? address;
  String? city;
  String? state;
  int? profileProgress;
  String? id;
  String? updatedOn;
  String? createdOn;
  String? profileImage; // New field for profile image URL or path

  UserModel({
    this.sId,
    this.fullName,
    this.email,
    this.password,
    this.phoneNumber,
    this.address,
    this.city,
    this.state,
    this.profileProgress,
    this.id,
    this.updatedOn,
    this.createdOn,
    this.profileImage,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'] ?? ''; // Default empty if null
    fullName = json['fullName'] ?? '';
    email = json['email'] ?? '';
    password = json['password']; // Allow null
    phoneNumber = json['phoneNumber'] ?? '';
    address = json['address'] ?? '';
    city = json['city'] ?? '';
    state = json['state'] ?? '';
    profileProgress = json['profileProgress'] ?? 0; // Default to 0
    id = json['id'] ?? '';
    updatedOn = json['updatedOn'] ?? '';
    createdOn = json['createdOn'] ?? '';
    profileImage = json['profileImage'] ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'fullName': fullName,
      'email': email,
      'password': password,
      'phoneNumber': phoneNumber,
      'address': address,
      'city': city,
      'state': state,
      'profileProgress': profileProgress,
      'id': id,
      'updatedOn': updatedOn,
      'createdOn': createdOn,
      'profileImage': profileImage,
    };
  }
}
