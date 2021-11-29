class ContactInfo {
  String phone;
  String email;
  ContactInfo({
    this.phone,
    this.email,
  });
  factory ContactInfo.fromJson(Map<String, dynamic> data) {
    return ContactInfo(
      phone: data['phone'] as String,
      email: data['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'email': email,
    };
  }
}
