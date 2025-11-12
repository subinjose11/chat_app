// ignore_for_file: use_build_context_synchronously

import 'package:chat_app/core/styles/app_strings.dart';
import 'package:chat_app/core/styles/text_styles.dart';
import 'package:chat_app/core/widget/custom_button.dart';
import 'package:chat_app/local/shared_prefs_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 50),
          Text(
            "Welcome to ChatApp",
            style: heading01,
          ),
          SizedBox(
            height: size.height / 2,
            child: Image.asset(Drawables.landingBg, height: 340, width: 340),
          ),
          SizedBox(height: size.height / 10),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
              style: subText14SB,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
              width: size.width * 0.75,
              child: CustomButton(
                  text: 'AGREE AND CONTINUE',
                  onPressed: () async {
                    await SharedPreferencesHelper.init();
                    await SharedPreferencesHelper.setBool("firstLogin",true);
                    context.go('/login');
                  })),
        ],
      )),
    );
  }
}
