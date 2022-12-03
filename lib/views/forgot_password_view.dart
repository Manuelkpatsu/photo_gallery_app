import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_gallery_app/bloc/app_bloc.dart';
import 'package:photo_gallery_app/bloc/app_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordView extends HookWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: 'Enter your email here...',
              ),
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
            ),
            TextButton(
              onPressed: () {
                final email = emailController.text.trim();
                context.read<AppBloc>().add(
                      AppEventForgotPassword(email: email),
                    );
              },
              child: const Text('Change password'),
            ),
            TextButton(
              onPressed: () {
                context.read<AppBloc>().add(
                      const AppEventGoToLogin(),
                    );
              },
              child: const Text('Login here!'),
            ),
          ],
        ),
      ),
    );
  }
}
