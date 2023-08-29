import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../core/common/managers/image_handler_provider.dart';
import '../../../../core/common/models/user_model.dart';
import '../../../../core/config/app_router.dart';
import '../../../../core/config/app_setup.dart';
import '../../../../core/services/logger.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../auth/data/repositories/user_repo/user_repo_impl.dart';

class EditProfileProvider extends ChangeNotifier {
  EditProfileProvider() {
    Logger.logEvent(
        className: 'ProfileSetupProvider', event: 'Provider Created');
  }

  UserModel? user;

  // form
  final profileSetupFormKey = GlobalKey<FormState>();
  final profileSkillsFormKey = GlobalKey<FormState>();

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  // variables

  bool _isLoading = false;
  bool _isUpdating = false;
  final _userRepo = getIt<UserRepoImpl>();
  final _skillsControllers = [TextEditingController()];
  File? _profilePic;

  // getters
  bool get isLoading => _isLoading;

  bool get isUpdating => _isUpdating;

  List<TextEditingController> get skillsControllers => _skillsControllers;

  File? get profilePic => _profilePic;

  // setters

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set isUpdating(bool value) {
    _isUpdating = value;
    notifyListeners();
  }

  set profilePic(File? value) {
    _profilePic = value;
    notifyListeners();
  }

  // methods

  loadData(UserModel? user) {
    isLoading = true;
    if (user != null) {
      this.user = user;
      fullNameController.text = user.fullName!;
      phoneController.text = user.phone!;
      locationController.text = user.location!;
      bioController.text = user.bio!;
      _skillsControllers.clear();
      for (var skill in user.skills) {
        _skillsControllers.add(TextEditingController(text: skill));
      }
    }
    isLoading = false;
  }

  addSkillController() {
    _skillsControllers.add(TextEditingController());
    notifyListeners();
  }

  pickImage({
    required BuildContext context,
    required ImageSource imageSource,
  }) async {
    final imageHandler =
        Provider.of<ImageHandlerProvider>(context, listen: false);
    try {
      final File? imageFile = await imageHandler.pickImage(
        context: context,
        imageSource: imageSource,
      );
      if (imageFile != null) {
        _profilePic = imageFile;
        notifyListeners();
      }
    } catch (e) {
      Logger.logEvent(
        className: 'ProfileSetupProvider',
        event: 'Error picking image: $e',
        methodName: 'pickImage',
      );
      rethrow;
    }
  }

  Future<void> updateUserProfile(BuildContext context) async {
    isUpdating = true;
    try {
      final nextRoute = _handleNextRoute(user?.fullName, context);
      final newUserData = await _newDataMap();
      final userJson = await _userRepo.updateUser(newUserData: newUserData);
      if (userJson != null) {
        AppConstants.userToken = userJson[AppStrings.userToken];
        // final UserModel user = UserModel.fromMap(userJson);
        notifyListeners();
        if (context.mounted) {
          if (nextRoute != AppRouter.profilePage) {
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pushReplacementNamed(nextRoute);
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        AppConstants.showSnackBar(
          context: context,
          message: e.toString(),
        );
      }
    }
    isUpdating = false;
  }

  _handleNextRoute(String? fullName, BuildContext context) {
    // if fullName that means user is logging in for the first time
    return fullName == null ? AppRouter.drawer : AppRouter.profilePage;
  }

  Future<Map<String, dynamic>> _newDataMap() async {
    final String imageUrl = await _handleUploadImage();
    // final imageData = ImageModel(
    //   url: imageUrl,
    //   createdAt: DateTime.now(),
    // ).toMap();
    return {
      AppStrings.userFullName: fullNameController.text,
      AppStrings.userPhone: phoneController.text,
      AppStrings.userLocation: locationController.text,
      AppStrings.userBio: bioController.text,
      AppStrings.userSkills:
          _skillsControllers.map((skill) => skill.text).toList(),
      AppStrings.userProfilePic: imageUrl,
    };
  }

  Future<String> _handleUploadImage() async {
    String url = '';
    if (_profilePic != null) {
      url = await ImageHandlerProvider.uploadImageAndGetUrl(_profilePic!);
    }
    return url;
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    locationController.dispose();
    for (var skillController in _skillsControllers) {
      skillController.dispose();
    }
    Logger.logEvent(
        className: 'ProfileSetupProvider', event: 'Provider Disposed');
    super.dispose();
  }
}
