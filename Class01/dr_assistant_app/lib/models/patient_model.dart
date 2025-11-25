class Patient {
  int? id;
  String name;
  String phone;
  String email;
  int age;
  String gender;
  String address;
  String notes;
  String? creationDate; // ✅ creationDate field

  Patient({
    this.id,
    required this.name,
    required this.phone,
    this.email = '',
    required this.age,
    required this.gender,
    required this.address,
    this.notes = '',
    this.creationDate, // ✅ Constructor mein shamil
  });

  // Convert a Patient object into a Map object
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'age': age,
      'gender': gender,
      'address': address,
      'notes': notes,
      'creationDate': creationDate, // ✅ toMap() mein shamil
    };
  }

  // Extract a Patient object from a Map object
  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? 'Male',
      address: map['address'] ?? '',
      notes: map['notes'] ?? '',
      creationDate: map['creationDate'], // ✅ fromMap() mein shamil
    );
  }
}