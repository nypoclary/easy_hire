class JobModel {
  final String id;
  final String role;
  final String company;
  final String salary;
  final String location;
  final String tag; // e.g., "Home Service"
  final String type; // e.g., "Part-Time"
  final String requirements;
  final String responsibilities;
  final Map<String, String> jobSummary;
  final String imageUrl; // optional, default placeholder allowed

  JobModel({
    required this.id,
    required this.role,
    required this.company,
    required this.salary,
    required this.location,
    required this.tag,
    required this.type,
    required this.requirements,
    required this.responsibilities,
    required this.jobSummary,
    required this.imageUrl,
  });

  /// Convert Firestore map → JobModel
  factory JobModel.fromMap(Map<String, dynamic> map, String docId) {
    return JobModel(
      id: docId,
      role: map['role'] ?? '',
      company: map['company'] ?? '',
      salary: map['salary'] ?? '',
      location: map['location'] ?? '',
      tag: map['tag'] ?? '',
      type: map['type'] ?? '',
      requirements: map['requirements'] ?? '',
      responsibilities: map['responsibilities'] ?? '',
      jobSummary: Map<String, String>.from(map['jobSummary'] ?? {}),
      imageUrl: map['imageUrl'] ?? '', // fallback handled in UI
    );
  }

  /// Convert JobModel → Firestore map
  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'company': company,
      'salary': salary,
      'location': location,
      'tag': tag,
      'type': type,
      'requirements': requirements,
      'responsibilities': responsibilities,
      'jobSummary': jobSummary,
      'imageUrl': imageUrl,
    };
  }
}
