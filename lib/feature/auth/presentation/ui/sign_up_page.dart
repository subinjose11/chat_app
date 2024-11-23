import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/utils/utils.dart';
import 'package:chat_app/core/widget/custom_button.dart';
import 'package:chat_app/feature/auth/presentation/controller/auth_controller.dart';
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
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('Create a account with your email id'),
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
