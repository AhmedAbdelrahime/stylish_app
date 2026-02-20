class UserModel {
  final String userId;
  final String email;
  final String? name;
  final String? image;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;

  const UserModel({
    required this.userId,
    required this.email,
    this.name,
    this.image,
    this.address,
    this.city,
    this.state,
    this.country,
    this.pincode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['id'],
      email: json['email'],
      name: json['full_name'],
      image: json['image'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      pincode: json['pincode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': name,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,
      'image': image,
    };
  }
}
