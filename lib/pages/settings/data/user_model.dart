class UserModel {
  final String userId;
  final String email;
  final String? name;
  final String? image;
  final String? address;
  final String? phone;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;
  final String? role;

  const UserModel({
    required this.userId,
    required this.email,
    this.name,
    this.image,
    this.address,
    this.phone,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.role,
  });

  bool get isAdmin {
    final normalizedRole = role?.trim().toLowerCase();
    return normalizedRole == 'admin';
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rawRole = json['role'];

    return UserModel(
      userId: json['id'],
      email: json['email'],
      name: json['full_name'],
      image: json['image'],
      address: json['address'],
      phone: json['phone'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      pincode: json['pincode'],
      role: rawRole is String ? rawRole : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': name,
      'address': address,
      'phone': phone,
      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,
      'image': image,
    };
  }

  UserModel copyWith({
    String? name,
    String? image,
    String? address,
    String? phone,
    String? city,
    String? state,
    String? country,
    String? pincode,
    String? role,
  }) {
    return UserModel(
      userId: userId,
      email: email,
      name: name ?? this.name,
      image: image ?? this.image,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      state: state ?? this.state,
      country: country ?? this.country,
      pincode: pincode ?? this.pincode,
      role: role ?? this.role,
    );
  }
}
