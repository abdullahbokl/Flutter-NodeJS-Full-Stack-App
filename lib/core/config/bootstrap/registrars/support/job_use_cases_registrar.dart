import '../../../service_locator.dart';
import '../../../../../features/home/domain/usecases/get_home_jobs_usecase.dart';
import '../../../../../features/jobs/data/repositories/jobs_repo.dart';
import '../../../../../features/jobs/domain/usecases/create_job_usecase.dart';
import '../../../../../features/jobs/domain/usecases/delete_job_usecase.dart';
import '../../../../../features/jobs/domain/usecases/get_jobs_usecase.dart';
import '../../../../../features/jobs/domain/usecases/get_my_jobs_usecase.dart';
import '../../../../../features/jobs/domain/usecases/update_job_usecase.dart';

void registerJobUseCases() {
  serviceLocator.registerLazySingleton<GetHomeJobsUseCase>(
    () => GetHomeJobsUseCase(serviceLocator<JobsRepo>()),
  );
  serviceLocator.registerLazySingleton<GetJobsUseCase>(
    () => GetJobsUseCase(serviceLocator<JobsRepo>()),
  );
  serviceLocator.registerLazySingleton<CreateJobUseCase>(
    () => CreateJobUseCase(serviceLocator<JobsRepo>()),
  );
  serviceLocator.registerLazySingleton<GetMyJobsUseCase>(
    () => GetMyJobsUseCase(serviceLocator<JobsRepo>()),
  );
  serviceLocator.registerLazySingleton<UpdateJobUseCase>(
    () => UpdateJobUseCase(serviceLocator<JobsRepo>()),
  );
  serviceLocator.registerLazySingleton<DeleteJobUseCase>(
    () => DeleteJobUseCase(serviceLocator<JobsRepo>()),
  );
}
