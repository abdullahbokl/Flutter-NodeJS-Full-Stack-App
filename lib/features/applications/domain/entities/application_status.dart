class ApplicationStatus {
  static const String applied = 'applied';
  static const String underReview = 'under_review';
  static const String interview = 'interview';
  static const String accepted = 'accepted';
  static const String rejected = 'rejected';

  static const List<String> flow = <String>[
    applied,
    underReview,
    interview,
    accepted,
    rejected,
  ];

  static String normalize(String status) {
    switch (status) {
      case 'pending':
        return applied;
      case 'reviewed':
        return underReview;
      case underReview:
      case interview:
      case accepted:
      case rejected:
      case applied:
        return status;
      default:
        return applied;
    }
  }

  static String label(String status) {
    switch (normalize(status)) {
      case underReview:
        return 'Under Review';
      case interview:
        return 'Interview';
      case accepted:
        return 'Accepted';
      case rejected:
        return 'Rejected';
      case applied:
      default:
        return 'Applied';
    }
  }
}

