import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:photo_gallery_app/auth/auth_error.dart';

@immutable
abstract class AppState {
  final bool isLoading;
  final AuthError? authError;
  final bool isSnackBar;
  final String? snackBarTitle;
  final String? snackBarDescription;

  const AppState({
    required this.isLoading,
    this.authError,
    required this.isSnackBar,
    this.snackBarTitle,
    this.snackBarDescription,
  });
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;

  const AppStateLoggedIn({
    required bool isLoading,
    required this.user,
    required this.images,
    AuthError? authError,
    required bool isSnackBar,
    String? snackBarTitle,
    String? snackBarDescription,
  }) : super(
          isLoading: isLoading,
          authError: authError,
          isSnackBar: isSnackBar,
          snackBarTitle: snackBarTitle,
          snackBarDescription: snackBarDescription,
        );

  @override
  bool operator ==(other) {
    final otherClass = other;
    if (otherClass is AppStateLoggedIn) {
      return isLoading == otherClass.isLoading &&
          user.uid == otherClass.user.uid &&
          images.length == otherClass.images.length;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => Object.hash(user.uid, images);

  @override
  String toString() => 'AppStateLoggedIn, images.length = ${images.length}';
}

@immutable
class AppStateLoggedOut extends AppState {
  const AppStateLoggedOut({
    required bool isLoading,
    AuthError? authError,
    required bool isSnackBar,
    String? snackBarTitle,
    String? snackBarDescription,
  }) : super(
          isLoading: isLoading,
          authError: authError,
          isSnackBar: isSnackBar,
          snackBarTitle: snackBarTitle,
          snackBarDescription: snackBarDescription,
        );

  @override
  String toString() =>
      'AppStateLoggedOut, isLoading = $isLoading, authError = $authError';
}

@immutable
class AppStateIsInRegistrationView extends AppState {
  const AppStateIsInRegistrationView({
    required bool isLoading,
    AuthError? authError,
    required bool isSnackBar,
    String? snackBarTitle,
    String? snackBarDescription,
  }) : super(
          isLoading: isLoading,
          authError: authError,
          isSnackBar: isSnackBar,
          snackBarTitle: snackBarTitle,
          snackBarDescription: snackBarDescription,
        );

  @override
  String toString() =>
      'AppStateIsInRegistrationView, isLoading = $isLoading, authError = $authError';
}

@immutable
class AppStateIsInForgotPasswordView extends AppState {
  const AppStateIsInForgotPasswordView({
    required bool isLoading,
    AuthError? authError,
    required bool isSnackBar,
    String? snackBarTitle,
    String? snackBarDescription,
  }) : super(
          isLoading: isLoading,
          authError: authError,
          isSnackBar: isSnackBar,
          snackBarTitle: snackBarTitle,
          snackBarDescription: snackBarDescription,
        );

  @override
  String toString() =>
      'AppStateIsInForgotPasswordView, isLoading = $isLoading, authError = $authError';
}

extension GetUser on AppState {
  User? get user {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.user;
    } else {
      return null;
    }
  }
}

extension GetImages on AppState {
  Iterable<Reference>? get images {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.images;
    } else {
      return null;
    }
  }
}
