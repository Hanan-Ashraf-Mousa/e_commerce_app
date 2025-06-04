
class UserModel {
  String id;
  String name;
  String email;
  String phone;
  String dob;
  String address;
  String gender;
  String path;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.gender,
    required this.address,
    required this.dob,
    required this.path,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final cartItemsJson = json['cartItems'] as List<dynamic>?;
    final favouriteItemsJson = json['favouriteItems'] as List<dynamic>?;
    return UserModel(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      gender: json['gender'],
      address: json['address'],
      dob: json['dob'],
      path: json['path'],
     );
  }
  Map<String, dynamic> toJson(){
    return {
      'id':id,
      'name':name,
      'phone':phone,
      'email':email,
      'dob':dob,
      'address':address,
      'gender':gender,
      'path':path,
    };
  }
}


