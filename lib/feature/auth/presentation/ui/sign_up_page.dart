import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/core/styles/app_strings.dart';
import 'package:chat_app/core/styles/text_styles.dart';
import 'package:chat_app/core/widget/custom_button.dart';
import 'package:chat_app/core/widget/custom_text_field.dart';
import 'package:chat_app/feature/auth/presentation/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void signUp() {
    if (_formKey.currentState?.validate() ?? false) {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      ref
          .read(authControllerProvider)
          .registerWithEmail(context, email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    AppColors.primaryDark,
                    AppColors.scaffoldBackgroundDark,
                    AppColors.primaryDark.withValues(alpha: 0.8),
                  ]
                : [
                    AppColors.primaryBlue,
                    AppColors.primaryDark,
                    AppColors.primaryBlue.withValues(alpha: 0.9),
                  ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                      SizedBox(height: isSmallScreen ? 20 : 40),
                      // App Logo and Welcome Text in Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.white.withValues(alpha: 0.1)
                                  : AppColors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? AppColors.white.withValues(alpha: 0.05)
                                      : AppColors.white.withValues(alpha: 0.1),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              Drawables.appLogo,
                              height: isSmallScreen ? 50 : 60,
                              width: isSmallScreen ? 50 : 60,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Create Account',
                                style: heading01.copyWith(
                                  color: AppColors.white,
                                  fontSize: isSmallScreen ? 24 : 28,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Sign up to get started',
                                style: subText14SB.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.9),
                                  fontSize: isSmallScreen ? 12 : 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 32 : 40),
                      // Form Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.cardBackgroundDark
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withValues(alpha: 0.5)
                                  : Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              CustomTextField(
                                controller: _emailController,
                                hintText: "Email address",
                                prefixIcon: const Icon(
                                  Icons.mail_outline_rounded,
                                  color: AppColors.primaryBlue,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!value.contains('@')) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                controller: _passwordController,
                                hintText: "Password",
                                isPasswordField: true,
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: AppColors.primaryBlue,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                height: 52,
                                child: CustomButton(
                                  onPressed: signUp,
                                  text: 'Sign Up',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: AppColors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "or",
                              style: subText14SB.copyWith(
                                color: AppColors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              color: AppColors.white.withValues(alpha: 0.3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Google Sign In Button
                      Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.cardBackgroundDark
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: isDark
                              ? Border.all(
                                  color: AppColors.gray700,
                                  width: 1,
                                )
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: isDark
                                  ? Colors.black.withValues(alpha: 0.5)
                                  : Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await ref
                                .read(authControllerProvider)
                                .signInWithGoogle(context);
                          },
                          icon: Image.asset(
                            'assets/drawables/google_logo.png',
                            height: 32,
                            width: 32,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.g_mobiledata,
                                size: 32,
                                color: isDark
                                    ? AppColors.white
                                    : AppColors.primaryBlue,
                              );
                            },
                          ),
                          label: Text(
                            'Continue with Google',
                            style: subText14SB.copyWith(
                              color: isDark
                                  ? AppColors.white
                                  : AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 24 : 32),
                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: subText14M.copyWith(
                              color: AppColors.white.withValues(alpha: 0.8),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              context.go('/login');
                              _emailController.clear();
                              _passwordController.clear();
                            },
                            child: Text(
                              'Log in',
                              style: heading04.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 20 : 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
