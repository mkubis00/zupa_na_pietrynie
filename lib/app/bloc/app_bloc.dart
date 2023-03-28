import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
          authenticationRepository.currentUser.isNotEmpty
              ? AppState.authenticated(authenticationRepository.currentUser, false, "empty")
              : const AppState.unauthenticated(),
        ) {
    on<_AppUserChanged>(_onUserChanged);
    on<AppLogoutRequested>(_onLogoutRequested);
    on<AppDeleteUserRequested>(_onDeleteAccountRequested);
    _userSubscription = _authenticationRepository.user.listen(
      (user) => add(_AppUserChanged(user)),
    );
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;

  Future<void> _onUserChanged(_AppUserChanged event, Emitter<AppState> emit) async {
    bool isAdmin = await _authenticationRepository.isAdmin();
    String provider = await _authenticationRepository.getProvider();
    emit(
      event.user.isNotEmpty
          ? AppState.authenticated(event.user, isAdmin, provider)
          : const AppState.unauthenticated(),
    );

  }

  void _onLogoutRequested(AppLogoutRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.logOut());
  }

  void _onDeleteAccountRequested(
      AppDeleteUserRequested event, Emitter<AppState> emit) {
    unawaited(_authenticationRepository.deleteAccount());
    emit(AppState.unauthenticated());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
