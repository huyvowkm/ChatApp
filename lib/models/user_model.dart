class UserModel {
  UserModel({
    this.id = '', 
    this.createdAt = '',
    this.name = '', 
    this.email = '', 
    this.avatar = ''
  });

  String id;
  String createdAt;
  String name;
  String email;
  String avatar;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    createdAt: json['created_at'],
    name: json['name'],
    email: json['email'],
    avatar: json['avatar'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_at': createdAt,
    'name': name,
    'email': email,
    'avatar': avatar,
  };
}