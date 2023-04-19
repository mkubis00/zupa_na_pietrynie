
import 'package:authentication_repository/authentication_repository.dart';

class EventsRepository {
  EventsRepository({
    required AuthenticationRepository authenticationRepository,
}) :
_authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;
}