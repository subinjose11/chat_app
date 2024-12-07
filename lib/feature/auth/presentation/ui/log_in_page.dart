import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/core/widget/custom_button.dart';
import 'package:chat_app/feature/auth/presentation/controller/auth_controller.dart';
import 'package:chat_app/routes/app_route.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class LogInPage extends ConsumerStatefulWidget {
  const LogInPage({super.key});

  @override
  ConsumerState<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends ConsumerState<LogInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void logIn() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isNotEmpty && password.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .signInWithEmail(context, email, password);
    } else {
      showSnackBar(context: context, content: 'Fill out all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              const Text('Log in to Chat app with your email id'),
              const SizedBox(height: 10),
              const SizedBox(height: 5),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Email id',
                ),
              ),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(hintText: 'password'),
                obscureText: true,
              ),
              const Spacer(),
              SizedBox(
                width: 90,
                child: CustomButton(
                  onPressed: () {
                    logIn();
                  },
                  text: 'Log In',
                ),
              ),
              SizedBox(
                width: 90,
                child: CustomButton(
                  onPressed: () {
                 context.router.push(const SignUpRoute());
                  },
                  text: 'sign up',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
