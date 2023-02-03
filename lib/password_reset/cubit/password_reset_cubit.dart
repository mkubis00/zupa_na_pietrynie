import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'password_reset_state.dart';

class PasswordResetCubit extends Cubit<PasswordResetState> {
  PasswordResetCubit(this._authenticationRepository) : super(const PasswordResetState());

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

  Future<void> passwordReset() async {
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.passwordReset(email: state.email.value);
      emit(state.copyWith(status: FormzStatus.submissionSuccess));
    } on PasswordResetFailure catch (e) {
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
}