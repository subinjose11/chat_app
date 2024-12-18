import 'package:chat_app/feature/account/presentation/ui/account_screen.dart';
import 'package:chat_app/feature/auth/data/model/user_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_state.freezed.dart';

@freezed
class AccountState with _$AccountState {
  const factory AccountState({
    @Default(AccountStatus.idle) final AccountStatus accountStatus,
    @Default('') final String errorMessage,
    @Default(UserModel(
      id: "",
      user_name: "",
      avatar_url: '',
      updated_at: '',
    ))
    final UserModel userDetails,
  }) = _AccountState;
}
