import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_gallery_app/bloc/app_bloc.dart';
import 'package:photo_gallery_app/bloc/app_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends HookWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
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
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: 'Enter your password here...',
              ),
              keyboardAppearance: Brightness.dark,
              obscureText: true,
              obscuringCharacter: '◉',
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  context.read<AppBloc>().add(
                        const AppEventGoToForgotPassword(),
                      );
                },
                child: const Text('Forgot password?'),
              ),
            ),
            TextButton(
              onPressed: () {
                final email = emailController.text.trim();
                final password = passwordController.text.trim();
                context.read<AppBloc>().add(
                      AppEventLogin(
                        email: email,
                        password: password,
                      ),
                    );
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                context.read<AppBloc>().add(
                      const AppEventGoToRegisteration(),
                    );
              },
              child: const Text('Not registered yet? Register here!'),
            ),
          ],
        ),
      ),
    );
  }
}
