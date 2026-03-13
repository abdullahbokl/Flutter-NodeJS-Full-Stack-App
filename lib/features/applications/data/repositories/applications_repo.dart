import '../models/job_application_model.dart';

abstract class ApplicationsRepo {
  Future<JobApplicationModel> applyForJob({
    required String jobId,
    required String coverLetter,
  });

  Future<List<JobApplicationModel>> getMyApplications();

  Future<List<JobApplicationModel>> getReceivedApplications();

  Future<JobApplicationModel> updateApplicationStatus({
    required String applicationId,
    required String status,
  });
}

