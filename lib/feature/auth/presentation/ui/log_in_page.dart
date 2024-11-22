import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:chat_app/core/styles/text_styles.dart';
import 'package:chat_app/core/widget/custom_button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

@RoutePage()
class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}
class _LogInPageState extends State<LogInPage> {
   final phoneController = TextEditingController();
  Country? country;

  @override
  void dispose() {
    super.dispose();
    phoneController.dispose();
  }

   void pickCountry() {
     showCountryPicker(
       context: context,
       showPhoneCode: true,
       onSelect: (Country selectedCountry) {
         setState(() {
           country = selectedCountry;
           log("Selected Country: ${country!.displayName}");
         });
       },
     );
   }

  void sendPhoneNumber() {
    String phoneNumber = phoneController.text.trim();
    if (country != null && phoneNumber.isNotEmpty) {
      // ref.read(authControllerProvider)
      //     .signInWithPhone(context, '+${country!.phoneCode}$phoneNumber');
    } else {
      // showSnackBar(context: context, content: 'Fill out all the fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
         title:  Text('Enter your phone number',style: subText16M,),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
              const Text('ChatApp will need to verify your phone number.'),
            const SizedBox(height: 10),
            TextButton(
                  onPressed: (){pickCountry();},
                  child: const Text('Pick Country'),
                ),
                 const SizedBox(height: 5),
            Row(
              children: [
               if (country != null) Text('+${country!.phoneCode}'),
                const SizedBox(width: 10),
                SizedBox(
                  width: size.width * 0.7,
                  child: TextField(
                    controller: phoneController,
                    keyboardType:TextInputType.number ,
                    decoration: const InputDecoration(
                      hintText: 'phone number',
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: 90,
              child: CustomButton(
                onPressed: (){},
                text: 'NEXT',
              ),
            ),
          ],
        ),
      ),
    );
  }
}