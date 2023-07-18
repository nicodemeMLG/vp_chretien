class UserModel{
  String? uid;
  String? name;
  String? email;
  String? mobile;
  String? locality;
  bool? type;


  UserModel({this.email, this.mobile, this.name, this.locality, this.uid, this.type });

  factory UserModel.fromMap(map){
    return UserModel(
      uid: map['Uid'],
      email: map['email'],
      mobile: map['mobile'],
      name: map['name'],
      locality: map['locality'],
      type: map['type'],

    );

  }

  Map<String,dynamic> toMap(){
    return {
      'Uid': uid,
      'email': email,
      'name': name,
      'mobile': mobile,
      'locality':locality,
      'type': type,

    };
  }




}