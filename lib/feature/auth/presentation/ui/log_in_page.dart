import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

@RoutePage()
class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title:  Text('Enter your phone number',style: subText16M,),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              TextButton(
                    onPressed: (){},
                    child: const Text('Pick Country'),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}