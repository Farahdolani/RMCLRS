class UserModel {
  String? email;
  String? password;
  String? uid;
  String? name;
  String? deviceid;
  String? thirapistid;
  String? progress;

// receiving data
  UserModel(
      {this.uid,
      this.email,
      this.password,
      this.name,
      this.deviceid,
      this.thirapistid,
      this.progress});
  factory UserModel.fromMap(map) {
    return UserModel(
        uid: map['uid'],
        email: map['email'],
        name: map['name'],
        password: map['password'],
        deviceid: map['deviceid'],
        thirapistid: map['thirapistid'],
        progress: map['progress']);
  }
// sending data
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      'deviceid': deviceid,
      'thirapistid': thirapistid,
      'progress': progress,
    };
  }
}
