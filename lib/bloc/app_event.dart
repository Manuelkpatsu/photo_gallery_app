import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppEvent {
  const AppEvent();
}

@immutable
class AppEventUploadImage implements AppEvent {
  final String filePathToUpload;

  const AppEventUploadImage({required this.filePathToUpload});
}

@immutable
class AppEventDeleteAccount implements AppEvent {
  const AppEventDeleteAccount();
}

@immutable
class AppEventLogout implements AppEvent {
  const AppEventLogout();
}

@immutable
class AppEventInitialize implements AppEvent {
  const AppEventInitialize();
}

@immutable
class AppEventLogin implements AppEvent {
  final String email;
  final String password;

  const AppEventLogin({required this.email, required this.password});
}

@immutable
class AppEventGoToRegisteration implements AppEvent {
  const AppEventGoToRegisteration();
}

@immutable
class AppEventRegister implements AppEvent {
  final String email;
  final String password;

  const AppEventRegister({required this.email, required this.password});
}

@immutable
class AppEventGoToLogin implements AppEvent {
  const AppEventGoToLogin();
}

@immutable
class AppEventGoToForgotPassword implements AppEvent {
  const AppEventGoToForgotPassword();
}

@immutable
class AppEventForgotPassword implements AppEvent {
  final String email;

  const AppEventForgotPassword({required this.email});
}
