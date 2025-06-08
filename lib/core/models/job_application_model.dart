class JobApplicationModel {
  final String id;
  final String jobId;
  final String applicantId;
  final String applicantName;
  final String applicantEmail;
  final String education;
  final String? otherRequests;
  final ApplicationStatus status;
  final DateTime appliedAt;

  // Job details for display (denormalized for performance)
  final String jobTitle;
  final String companyName;
  final String salary;
  final String? companyPhotoUrl;
  final List<String> tags;

  JobApplicationModel({
    required this.id,
    required this.jobId,
    required this.applicantId,
    required this.applicantName,
    required this.applicantEmail,
    required this.education,
    this.otherRequests,
    required this.status,
    required this.appliedAt,
    required this.jobTitle,
    required this.companyName,
    required this.salary,
    this.companyPhotoUrl,
    required this.tags,
  });

  factory JobApplicationModel.fromMap(Map<String, dynamic> map, String docId) {
    return JobApplicationModel(
      id: docId,
      jobId: map['jobId'] as String? ?? '',
      applicantId: map['applicantId'] as String? ?? '',
      applicantName: map['applicantName'] as String? ?? '',
      applicantEmail: map['applicantEmail'] as String? ?? '',
      education: map['education'] as String? ?? '',
      otherRequests: map['otherRequests'] as String?,
      status: ApplicationStatus.values.firstWhere(
        (e) => e.toString().split('.').last == map['status'],
        orElse: () => ApplicationStatus.pending,
      ),
      appliedAt: DateTime.tryParse(map['appliedAt'] as String? ?? '') ??
          DateTime.now(),
      jobTitle: map['jobTitle'] as String? ?? '',
      companyName: map['companyName'] as String? ?? '',
      salary: map['salary'] as String? ?? '',
      companyPhotoUrl: map['companyPhotoUrl'] as String?,
      tags: (map['tags'] is List)
          ? List<String>.from(map['tags'].whereType<String>())
          : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'jobId': jobId,
      'applicantId': applicantId,
      'applicantName': applicantName,
      'applicantEmail': applicantEmail,
      'education': education,
      'otherRequests': otherRequests,
      'status': status.toString().split('.').last,
      'appliedAt': appliedAt.toIso8601String(),
      'jobTitle': jobTitle,
      'companyName': companyName,
      'salary': salary,
      'companyPhotoUrl': companyPhotoUrl,
      'tags': tags,
    };
  }
}

enum ApplicationStatus { pending, accepted, rejected }
