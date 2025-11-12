// ignore_for_file: use_build_context_synchronously
import 'package:chat_app/core/styles/app_colors.dart';
import 'package:chat_app/core/styles/app_dimens.dart';
import 'package:chat_app/core/styles/app_strings.dart';
import 'package:chat_app/core/styles/text_styles.dart';
import 'package:chat_app/feature/account/presentation/controller/account_controller.dart';
import 'package:chat_app/feature/account/presentation/widget/account_app_bar.dart';
import 'package:chat_app/feature/home/presentation/widget/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(accountControllerProvider.notifier).fetchAccountDetails(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final accountStatus = ref.watch(
        accountControllerProvider.select((value) => value.accountStatus));
    final userData = ref.watch(accountControllerProvider);
    return Scaffold(
      appBar: const CustomAppBar(appWidget: AccountAppBar(title: "Account")),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: (accountStatus == AccountStatus.loading)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (accountStatus == AccountStatus.success) ...[
                      Row(
                        children: [
                          userData.userDetails.avatar_url == null
                              ? CircleAvatar(
                                  radius: 40,
                                  child: Image.asset(Drawables.noDp),
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      userData.userDetails.avatar_url!),
                                  radius: 40,
                                ),
                          dimenWidth16,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Hello",
                                  style: subText14M,
                                ),
                                Text(
                                  userData.userDetails.user_name ?? "",
                                  style: subText16SB,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => context.push('/edit-profile',
                                extra: userData.userDetails),
                            icon: const Icon(
                              Icons.edit_rounded,
                              color: AppColors.gray400,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ]
                  ],
                ),
              ),
      ),
    );
  }
}

enum AccountStatus {
  idle,
  loading,
  success,
  failed,
}
