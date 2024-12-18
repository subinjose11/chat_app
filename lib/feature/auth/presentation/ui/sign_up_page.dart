import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/styles/text_styles.dart';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/core/widget/custom_button.dart';
import 'package:chat_app/core/widget/custom_text_field.dart';
import 'package:chat_app/feature/auth/presentation/controller/auth_controller.dart';
import 'package:chat_app/routes/app_route.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@RoutePage()
class SignUpPage extends ConsumerStatefulWidget{
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
   void signUp() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email.isNotEmpty && password.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .registerWithEmail(context, email, password);
    } else {
      showSnackBar(context: context, content: 'Fill out all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
             Text('Register', style: heading01),
                const SizedBox(height: 16),
             Text('Create a account with your email', style: subText14SB,),
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
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'Already have an account?',
                  style: subText14M,
                ),
                GestureDetector(
                  onTap: () {
                    context.router.replace(const LogInRoute());
                    _emailController.clear();
                    _passwordController.clear();
                  },
                  child: Text(
                    'Login',
                    style: heading04,
                  ),
                ),
              ]),
            const Spacer(),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  onPressed: () {
                   signUp();
                  },
                  text: 'Register',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
