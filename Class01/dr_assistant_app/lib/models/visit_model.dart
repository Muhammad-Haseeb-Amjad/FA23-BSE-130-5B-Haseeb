class Visit {
  int? id;
  int patientId; // Patient se link karne ke liye
  String date;
  String diagnosis;
  String treatment;
  String notes;
  String? prescriptionImagePath; // Optional field for image path

  Visit({
    this.id,
    required this.patientId,
    required this.date,
    required this.diagnosis,
    this.treatment = '',
    this.notes = '',
    this.prescriptionImagePath,
  });

  // Convert Visit object to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patient_id': patientId,
      'visit_date': date,
      'diagnosis': diagnosis,
      'treatment': treatment,
      'notes': notes,
      'prescription_image_path': prescriptionImagePath,
    };
  }

  // Extract a Visit object from a Map object
  factory Visit.fromMap(Map<String, dynamic> map) {
    return Visit(
      id: map['id'],
      patientId: map['patient_id'],
      date: map['visit_date'] ?? '',
      diagnosis: map['diagnosis'] ?? '',
      treatment: map['treatment'] ?? '',
      notes: map['notes'] ?? '',
      prescriptionImagePath: map['prescription_image_path'],
    );
  }
}