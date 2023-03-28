import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

import '../../bloc/main_screen_bloc.dart';

class EditButton extends StatelessWidget {
  const EditButton({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  Widget build(BuildContext context) {
    return
      IconButton(
        onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: const Text(
                    'Czy chcesz zmodyfikować post?'),
                content: const Text(
                    'Pamiętaj, zmiany będą widoczne dla wszytskich użytkowników.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(
                            context,
                            'Cancel'),
                    child: const Text(
                        'Anuluj',
                        style: TextStyle(
                            color:
                            AppColors.BLACK)),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pop(
                            context,
                            'Cancel'),
                    child: const Text(
                        'Edytuj',
                        style: TextStyle(
                            color:
                            AppColors.FACEBOOK_BLUE)),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<MainScreenBloc>().add(DeletePost(post));
                      Navigator.pop(
                          context);
                    },
                    child: const Text(
                        'Usuń',
                        style: TextStyle(
                            color:
                            AppColors.RED)),
                  ),
                ],
              ),
        ),
        icon: Icon(IconData(0xf6fb,
            fontFamily:
            'MaterialIcons')));
  }
}
