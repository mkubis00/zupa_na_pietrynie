import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

import '../../bloc/main_screen_bloc.dart';

class EditButton extends StatelessWidget {
  EditButton({Key? key, required this.post}) : super(key: key);

  final Post post;
  final TextEditingController msgController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    msgController.text = post.postContent;
    return IconButton(
        onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Czy chcesz zmodyfikować post?'),
                content: const Text(
                    'Pamiętaj, zmiany będą widoczne dla wszytskich użytkowników.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Anuluj',
                        style: TextStyle(color: AppColors.BLACK)),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Edycja posta"),
                              content: Container(
                                height: 250,
                                width: width,
                                child:
                                TextFormField(
                                  controller: msgController,
                                  cursorColor: AppColors.BLACK,
                                  maxLines: 12,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: AppColors.BLACK),
                                    ),
                                    border: UnderlineInputBorder(),
                                    hintText: MainScreenStrings.ADD_NEW_POST_CONTENT,
                                  ),
                                )
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  child: const Text('Anuluj',
                                      style: TextStyle(color: AppColors.BLACK)),),
                                TextButton(
                                  onPressed: () {
                                    if (10 <= msgController.value.text.length) {
                                      context.read<MainScreenBloc>().add(UpdatePost(post,msgController.value.text ));
                                      Navigator.pop(context);
                                    } else {
                                      null;
                                    }
                                  },
                                  child: const Text('Opublikuj zmianę',
                                      style: TextStyle(color: AppColors.FACEBOOK_BLUE)),)
                              ],
                            );
                          });
                    },
                    child: const Text('Edytuj',
                        style: TextStyle(color: AppColors.FACEBOOK_BLUE)),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<MainScreenBloc>().add(DeletePost(post));
                      Navigator.pop(context);
                    },
                    child: const Text('Usuń',
                        style: TextStyle(color: AppColors.RED)),
                  ),
                ],
              ),
            ),
        icon: Icon(IconData(0xf6fb, fontFamily: 'MaterialIcons')));
  }
}
