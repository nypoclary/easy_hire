class JobModel {
  final String id;
  final String role;
  final String company;
  final String salary;
  final String location;
  final String jobType;
  final String workMode;
  final String education;
  final String workingDays;
  final String workingHours;
  final String category;
  final String requirements;
  final String responsibilities;
  final String jobSummary;
  final String tag;
  final List<String> tags;
  final String imageUrl;
  final String? createdBy;
  final String? createdByName;
  final String? createdByPhotoUrl;

  JobModel({
    required this.id,
    required this.role,
    required this.company,
    required this.salary,
    required this.location,
    required this.jobType,
    required this.workMode,
    required this.education,
    required this.workingDays,
    required this.workingHours,
    required this.category,
    required this.requirements,
    required this.responsibilities,
    required this.jobSummary,
    required this.tag,
    required this.tags,
    required this.imageUrl,
    this.createdBy,
    this.createdByName,
    this.createdByPhotoUrl,
  });

  factory JobModel.fromMap(Map<String, dynamic> map, String docId) {
    return JobModel(
      id: docId,
      role: map['role'] is String ? map['role'] : '',
      company: map['company'] is String ? map['company'] : '',
      salary: map['salary'] is String ? map['salary'] : '',
      location: map['location'] is String ? map['location'] : '',
      jobType: map['jobType'] is String ? map['jobType'] : '',
      workMode: map['workMode'] is String ? map['workMode'] : '',
      education: map['education'] is String ? map['education'] : '',
      workingDays: map['workingDays'] is String ? map['workingDays'] : '',
      workingHours: map['workingHours'] is String ? map['workingHours'] : '',
      category: map['category'] is String ? map['category'] : '',
      requirements: map['requirements'] is String ? map['requirements'] : '',
      responsibilities: map['responsibilities'] is String ? map['responsibilities'] : '',
      jobSummary: map['jobSummary'] is String ? map['jobSummary'] : '',
      tag: map['tag'] is String ? map['tag'] : '',
      tags: (map['tags'] is List)
          ? List<String>.from(map['tags'].whereType<String>())
          : [],
      imageUrl: map['imageUrl'] is String ? map['imageUrl'] : '',
      createdBy: map['createdBy'] as String?,
      createdByName: map['createdByName'] as String?,
      createdByPhotoUrl: map['createdByPhotoUrl'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'company': company,
      'salary': salary,
      'location': location,
      'jobType': jobType,
      'workMode': workMode,
      'education': education,
      'workingDays': workingDays,
      'workingHours': workingHours,
      'category': category,
      'requirements': requirements,
      'responsibilities': responsibilities,
      'jobSummary': jobSummary,
      'tag': tag,
      'tags': tags,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'createdByName': createdByName,
      'createdByPhotoUrl': createdByPhotoUrl,
    };
  }
}
