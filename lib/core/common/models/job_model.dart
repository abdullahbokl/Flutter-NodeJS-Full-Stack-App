import '../../utils/app_strings.dart';

class JobModel {
  String title;
  String description;
  String location;
  String salary;
  String company;
  String period;
  String contract;
  List<String> requirements;
  String imageUrl;
  String agentId;

  JobModel({
    required this.title,
    required this.description,
    required this.location,
    required this.salary,
    required this.company,
    required this.period,
    required this.contract,
    required this.requirements,
    required this.imageUrl,
    required this.agentId,
  });

  factory JobModel.fromMap(Map<String, dynamic> json) {
    return JobModel(
      title: json[AppStrings.jobTitle],
      description: json[AppStrings.jobDescription],
      location: json[AppStrings.jobLocation],
      salary: json[AppStrings.jobSalary],
      company: json[AppStrings.jobCompany],
      period: json[AppStrings.jobPeriod],
      contract: json[AppStrings.jobContract],
      requirements: List<String>.from(json[AppStrings.jobRequirements]),
      imageUrl: json[AppStrings.jobImageUrl],
      agentId: json[AppStrings.jobAgentId],
    );
  }

  Map<String, dynamic> toMap() => {
        AppStrings.jobTitle: title,
        AppStrings.jobDescription: description,
        AppStrings.jobLocation: location,
        AppStrings.jobSalary: salary,
        AppStrings.jobCompany: company,
        AppStrings.jobPeriod: period,
        AppStrings.jobContract: contract,
        AppStrings.jobRequirements: requirements,
        AppStrings.jobImageUrl: imageUrl,
        AppStrings.jobAgentId: agentId,
      };
}
