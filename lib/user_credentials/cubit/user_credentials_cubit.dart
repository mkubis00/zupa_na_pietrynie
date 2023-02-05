import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'user_credentials_state.dart';

class UserCredentialsCubit extends Cubit<UserCredentialUpdateState> {
  UserCredentialsCubit(this._authenticationRepository) : super(const UserCredentialUpdateState());

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

  Future<void> updateUserCredentials() async {
    if (!state.status.isValidated) return;
    emit(state.copyWith(status: FormzStatus.submissionInProgress));
    try {
      await _authenticationRepository.updateUserCredentials(
          email: state.email.value,
          name: state.name.value);
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
  }

