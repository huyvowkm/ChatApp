class UserModel {
  UserModel({
    this.id = '', 
    this.name = '', 
    this.email = '', 
    this.avatar = ''
  });

  String id;
  String name;
  String email;
  String avatar;

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    avatar: json['avatar'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'avatar': avatar,
  };
}