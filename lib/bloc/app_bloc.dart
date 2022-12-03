import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:photo_gallery_app/auth/auth_error.dart';
import 'package:photo_gallery_app/bloc/app_event.dart';
import 'package:photo_gallery_app/bloc/app_state.dart';
import 'package:photo_gallery_app/utils/upload_image.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(
          const AppStateLoggedOut(
            isLoading: false,
            isSnackBar: false,
          ),
        ) {
    // handle logging in
    on<AppEventLogin>((event, emit) async {
      // start loading
      emit(
        const AppStateLoggedOut(
          isLoading: true,
          isSnackBar: false,
        ),
      );

      final email = event.email;
      final password = event.password;
      try {
        // log the user in
        final credentials =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // fetch user's images
        final user = credentials.user!;
        final images = await _getImages(user.uid);

        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: images,
            isSnackBar: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedOut(
            isLoading: false,
            authError: AuthError.from(e),
            isSnackBar: false,
          ),
        );
      }
    });

    // handle go to login
    on<AppEventGoToLogin>((event, emit) {
      emit(
        const AppStateLoggedOut(
          isLoading: false,
          isSnackBar: false,
        ),
      );
    });

    // handle go to registration
    on<AppEventGoToRegisteration>((event, emit) {
      emit(
        const AppStateIsInRegistrationView(
          isLoading: false,
          isSnackBar: false,
        ),
      );
    });

    // handle go to forgot password
    on<AppEventGoToForgotPassword>((event, emit) {
      emit(
        const AppStateIsInForgotPasswordView(
          isLoading: false,
          isSnackBar: false,
        ),
      );
    });

    // handle registration
    on<AppEventRegister>((event, emit) async {
      // start loading
      emit(
        const AppStateIsInRegistrationView(
          isLoading: true,
          isSnackBar: false,
        ),
      );

      final email = event.email;
      final password = event.password;
      try {
        // create the user
        final credentials =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: credentials.user!,
            images: const [],
            isSnackBar: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateIsInRegistrationView(
            isLoading: false,
            authError: AuthError.from(e),
            isSnackBar: false,
          ),
        );
      }
    });

    // handle forgot password
    on<AppEventForgotPassword>((event, emit) async {
      // start loading
      emit(
        const AppStateIsInForgotPasswordView(
          isLoading: true,
          isSnackBar: false,
        ),
      );

      final email = event.email;
      try {
        /// send password reset email and
        /// emit logged out state so user
        /// can sign in with new password
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

        emit(
          const AppStateLoggedOut(
            isLoading: false,
            isSnackBar: true,
            snackBarTitle: 'Success',
            snackBarDescription:
                'A reset password link has been sent to your email',
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateIsInForgotPasswordView(
            isLoading: false,
            authError: AuthError.from(e),
            isSnackBar: false,
          ),
        );
      }
    });

    // handle initial state of the application
    on<AppEventInitialize>((event, emit) async {
      // get the current user;
      final user = FirebaseAuth.instance.currentUser;
      // log the user out if we don'thave a current user
      if (user == null) {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
            isSnackBar: false,
          ),
        );
      } else {
        // fetch the user's uploaded images
        final images = await _getImages(user.uid);
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: images,
            isSnackBar: false,
          ),
        );
      }
    });

    // handle logging out
    on<AppEventLogout>((event, emit) async {
      // start loading
      emit(
        const AppStateLoggedOut(
          isLoading: true,
          isSnackBar: false,
        ),
      );

      // log the user out
      await FirebaseAuth.instance.signOut();

      // log the user out in the UI as well
      emit(
        const AppStateLoggedOut(
          isLoading: false,
          isSnackBar: false,
        ),
      );
    });

    // handle account deletion
    on<AppEventDeleteAccount>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      // log the user out if we don'thave a current user
      if (user == null) {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
            isSnackBar: false,
          ),
        );
        return;
      }

      // start the loading process
      emit(
        AppStateLoggedIn(
          isLoading: true,
          user: user,
          images: state.images ?? [],
          isSnackBar: false,
        ),
      );

      // delete the user's images folder
      try {
        // delete user's images folder
        final folderContents =
            await FirebaseStorage.instance.ref(user.uid).listAll();
        for (final item in folderContents.items) {
          await item.delete().catchError((_) {}); // maybe handle the error
        }

        // delete the folder itself
        await FirebaseStorage.instance
            .ref(user.uid)
            .delete()
            .catchError((_) {});

        // delete the user
        await user.delete();

        // log the user out
        await FirebaseAuth.instance.signOut();

        // log the user out in the UI as well
        emit(
          const AppStateLoggedOut(
            isLoading: false,
            isSnackBar: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: state.images ?? [],
            authError: AuthError.from(e),
            isSnackBar: false,
          ),
        );
      } on FirebaseException {
        /// we might not be able to delete the folder
        /// log the user out
        emit(
          const AppStateLoggedOut(
            isLoading: false,
            isSnackBar: false,
          ),
        );
      }
    });

    // handle uploading images
    on<AppEventUploadImage>((event, emit) async {
      final user = state.user;

      /// log user out if we don't have an actual
      /// user in app state
      if (user == null) {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
            isSnackBar: false,
          ),
        );
        return;
      }

      // start the loading process
      emit(
        AppStateLoggedIn(
          isLoading: true,
          user: user,
          images: state.images ?? [],
          isSnackBar: false,
        ),
      );

      // upload the file
      final file = File(event.filePathToUpload);
      await uploadImage(file: file, userId: user.uid);
      // after upload is complete, grab the latest file references
      final images = await _getImages(user.uid);
      // emit the new images and turn off loading
      emit(
        AppStateLoggedIn(
          isLoading: false,
          user: user,
          images: images,
          isSnackBar: false,
        ),
      );
    });
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);
}
