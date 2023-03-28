part of 'app_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
}

class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = User.empty,
    this.isAdmin = false,
    this.loginProvider = "empty"
  });

  const AppState.authenticated(User user, bool isAdmin, String loginProvider)
      : this._(status: AppStatus.authenticated, user: user, isAdmin: isAdmin, loginProvider: loginProvider );

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  final AppStatus status;
  final User user;
  final bool isAdmin;
  final String loginProvider;

  @override
  List<Object> get props => [status, user, isAdmin, loginProvider];
}
