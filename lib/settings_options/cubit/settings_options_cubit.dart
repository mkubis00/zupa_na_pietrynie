import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'settings_options_state.dart';

class SettingOptionsCubit extends Cubit<SettingOptionsState> {
  SettingOptionsCubit(this._authenticationRepository)
      : super(const SettingOptionsState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        status: Formz.validate([email]),
      ),
    );
  }

  void nameChanged(String value) {
    final name = Name.dirty(value);
    emit(
      state.copyWith(
        name: name,
        status: Formz.validate([name]),
      ),
    );
  }

  Future<void> updateUserName() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.updateUserName(name: state.name.value);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on UpdateUserCredentialsFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzStatus.submissionFailure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  Future<void> updateUserEmail() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.updateUserEmail(email: state.email.value);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on UpdateUserCredentialsFailure catch (e) {
      emit(
        state.copyWith(
          errorMessage: e.message,
          status: FormzStatus.submissionFailure,
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  // Future<void> updateUserCredentials() async {
  //   if (!state.status.isValidated) return;
  //   emit(state.copyWith(status: FormzStatus.submissionInProgress));
  //   try {
  //     await _authenticationRepository.updateUserCredentials(
  //         email: state.email.value, name: state.name.value);
  //     emit(state.copyWith(status: FormzStatus.submissionSuccess));
  //   } on UpdateUserCredentialsFailure catch (e) {
  //     emit(
  //       state.copyWith(
  //         errorMessage: e.message,
  //         status: FormzStatus.submissionFailure,
  //       ),
  //     );
  //   } catch (_) {
  //     emit(state.copyWith(status: FormzStatus.submissionFailure));
  //   }
  // }

// Future<void> deleteAccount() async {
//   if (!state.status.isValidated) return;
//   emit(state.copyWith(status: FormzStatus.submissionInProgress));
//   try {
//     await _authenticationRepository.deleteAccount();
//     emit(state.copyWith(status: FormzStatus.submissionSuccess));
//   } catch (_) {
//     emit(state.copyWith(status: FormzStatus.submissionFailure));
//   }
// }
}
