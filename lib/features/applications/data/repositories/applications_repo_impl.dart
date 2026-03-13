import '../../../../core/errors/server_error_handler.dart';
import '../../../../core/services/api_services.dart';
import '../../../../core/utils/api_endpoints.dart';
import '../models/job_application_model.dart';
import 'applications_repo.dart';

class ApplicationsRepoImpl implements ApplicationsRepo {
  final ApiServices _apiServices;

  ApplicationsRepoImpl(this._apiServices);

  @override
  Future<JobApplicationModel> applyForJob({
    required String jobId,
    required String coverLetter,
  }) async {
    try {
      final raw = await _apiServices.post(
        endPoint: '${ApiEndpoints.jobs}/$jobId/apply',
        data: {'coverLetter': coverLetter},
      );
      final data = raw is Map && raw['data'] != null ? raw['data'] : raw;
      return JobApplicationModel.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      throw handleServerError(e);
    }
  }

  @override
  Future<List<JobApplicationModel>> getMyApplications() async {
    try {
      final raw = await _apiServices.get(endPoint: '${ApiEndpoints.applications}/mine');
      final data = raw is Map ? raw['data'] : raw;
      if (data is! List) return [];
      return data
          .map((item) => JobApplicationModel.fromMap(Map<String, dynamic>.from(item)))
          .toList();
    } catch (e) {
      throw handleServerError(e);
    }
  }

  @override
  Future<List<JobApplicationModel>> getReceivedApplications() async {
    try {
      final raw = await _apiServices.get(endPoint: '${ApiEndpoints.applications}/received');
      final data = raw is Map ? raw['data'] : raw;
      if (data is! List) return [];
      return data
          .map((item) => JobApplicationModel.fromMap(Map<String, dynamic>.from(item)))
          .toList();
    } catch (e) {
      throw handleServerError(e);
    }
  }

  @override
  Future<JobApplicationModel> updateApplicationStatus({
    required String applicationId,
    required String status,
  }) async {
    try {
      final raw = await _apiServices.patch(
        endPoint: '${ApiEndpoints.applications}/$applicationId/status',
        data: {'status': status},
      );
      final data = raw is Map && raw['data'] != null ? raw['data'] : raw;
      return JobApplicationModel.fromMap(Map<String, dynamic>.from(data));
    } catch (e) {
      throw handleServerError(e);
    }
  }
}

