// import 'package:authentication_repository/authentication_repository.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
//
// class UserCredentials extends StatelessWidget {
//   const UserCredentials({super.key});
//
//   static Page<void> page() => const MaterialPage<void>(child: LoginPage());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Login'),
//         backgroundColor: Colors.white,
//         shadowColor: Colors.white,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8),
//         // child: BlocProvider(
//         //   create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
//           child: const LoginForm(),
//         // ),
//       ),
//     );
//   }
// }
