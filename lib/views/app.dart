import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_gallery_app/bloc/app_bloc.dart';
import 'package:photo_gallery_app/bloc/app_event.dart';
import 'package:photo_gallery_app/bloc/app_state.dart';
import 'package:photo_gallery_app/bloc/snack_bars/info_snack_bar.dart';
import 'package:photo_gallery_app/dialogs/show_auth_error_dialog.dart';
import 'package:photo_gallery_app/loading/loading_screen.dart';
import 'package:photo_gallery_app/views/forgot_password_view.dart';
import 'package:photo_gallery_app/views/login_view.dart';
import 'package:photo_gallery_app/views/photo_gallery_view.dart';
import 'package:photo_gallery_app/views/register_view.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppBloc>(
      create: (_) => AppBloc()..add(const AppEventInitialize()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Photo Gallery',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: 'Loading..,',
              );
            } else {
              LoadingScreen.instance().hide();
            }

            final authError = appState.authError;
            if (authError != null) {
              showAuthErrorDialog(
                authError: authError,
                context: context,
              );
            }

            final isSnackBar = appState.isSnackBar;
            if (isSnackBar) {
              showInfoSnackBar(
                context: context,
                title: appState.snackBarTitle!,
                description: appState.snackBarDescription!,
              );
            }
          },
          builder: (context, appState) {
            if (appState is AppStateLoggedOut) {
              return const LoginView();
            } else if (appState is AppStateLoggedIn) {
              return const PhotoGalleryView();
            } else if (appState is AppStateIsInRegistrationView) {
              return const RegisterView();
            } else if (appState is AppStateIsInForgotPasswordView) {
              return const ForgotPasswordView();
            } else {
              return const Scaffold(
                body: Center(child: Text('No view')),
              );
            }
          },
        ),
      ),
    );
  }
}
