import 'package:chat_app/feature/home/presentation/widget/custom_app_bar.dart';
import 'package:chat_app/feature/status/presentation/widget/status_app_bar.dart';
import 'package:flutter/material.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({super.key});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      appBar: CustomAppBar(appWidget:   StatusAppBar(title: "Status")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Status screen body',
            ),
          ],
        ),
      ),
    );
  }
}