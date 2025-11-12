import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/styles/app_strings.dart';
import 'package:chat_app/core/styles/text_styles.dart';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/core/widget/custom_button.dart';
import 'package:chat_app/core/widget/custom_text_field.dart';
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
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Image.asset(Drawables.appLogo, height: 50),
              const SizedBox(height: 16),
              Text('Welcome Back!', style: heading01),
              const SizedBox(height: 8),
              Text(
                'Log in to Chat App with your email',
                style: subText14SB,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _emailController,
                hintText: "Email address",
                prefixIcon: const Icon(Icons.mail_outline_rounded),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
                prefixIcon: const Icon(Icons.lock_outline),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: () {
                    logIn();
                  },
                  text: 'Log In',
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("or", style: subText14SB),
                  ),
                  const Expanded(
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await ref.read(authControllerProvider).signInWithGoogle(context);
                  },
                  icon: Image.asset(
                    'assets/drawables/google_logo.png',
                    height: 24,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.g_mobiledata, size: 24);
                    },
                  ),
                  label: Text(
                    'Continue with Google',
                    style: subText14SB,
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'Dont have an account?',
                  style: subText14M,
                ),
                GestureDetector(
                  onTap: () {
                    context.router.replace(const SignUpRoute());
                    _emailController.clear();
                    _passwordController.clear();
                  },
                  child: Text(
                    'Sign up',
                    style: heading04,
                  ),
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
