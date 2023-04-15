import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:posts_repository/posts_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';

import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/main_screen/bloc/main_screen_bloc.dart';
import 'package:zupa_na_pietrynie/app/app.dart';
import 'package:zupa_na_pietrynie/home/home.dart';


class Comments extends StatefulWidget {
  const Comments({Key? key, required String this.postId, required bool this.isAdmin}) : super(key: key);

  final String postId;
  final bool isAdmin;

  @override
  State<Comments> createState() => _CommentsState(postId, isAdmin);
}

class _CommentsState extends State<Comments> {
  final String postId;
  final bool isAdmin;


  _CommentsState(this.postId, this.isAdmin);

  static String? chooseName(
      String ownerId, Set<UserToPost> usersToPosts) {
    for (UserToPost user in usersToPosts) {
      if (ownerId == user.id) {
        return user.name;
      }
    }
    return "Usunięty użytkownik";
  }

  static String? chooseAvatar(String ownerId, Set<UserToPost> usersToPosts) {
    for (UserToPost user in usersToPosts) {
      if (ownerId == user.id) {
        return user.photo;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final User user = context.select((AppBloc bloc) => bloc.state.user);
    return BlocListener<MainScreenBloc, MainScreenState>(
        listener: (context, state) {
      },
    child:

      BlocBuilder<MainScreenBloc, MainScreenState>(
        buildWhen: (previous, current) => previous.comments != current.comments,
        builder: (context, state) {
          switch (state.commentsStatus) {
            case FormzStatus.submissionSuccess:
              return Column(
                children: [
                  SizedBox(width: width * 0.9, child: Divider(color: AppColors.BLACK,)),
                  Container(
                    height: 150,
                    child: ListView.builder(
                      // Let the ListView know how many items it needs to build.
                      itemCount: state.comments[postId]?.length,
                      // Provide a builder function. This is where the magic happens.
                      // Convert each item into a widget based on the type of item it is.
                      itemBuilder: (context, index) {
                        final item = state.comments[postId]![index];

                        return ListTile(
                          key: UniqueKey(),

                          title: Padding(
                              padding: const EdgeInsets.only(bottom: 5.0),
                              child:
                              Row(
                                children: [

                                  Avatar(
                                    photo: chooseAvatar(
                                        item.ownerId!,
                                        state.usersToPosts),
                                    avatarSize: 15,),
                                  const SizedBox(width: 10),
                                  Text(chooseName(item.ownerId!, state.usersToPosts)!),
                                ],
                              )),

                          subtitle: Text(item.commentContent),
                          minVerticalPadding: 5, trailing: isAdmin == true || user.id == item.ownerId ? IconButton(
                          icon: const Icon(
                            IconData(0xe1b9, fontFamily: 'MaterialIcons',
                            ),
                            color: AppColors.RED,
                          ),
                          // the method which is called
                          // when button is pressed
                          onPressed: () {
                            context.read<MainScreenBloc>().add(CommentDelete(state.comments[postId]![index]));
                            setState(() {

                            });
                          },
                        ) : null,
                        );
                      },
                    ),
                  ),
                  SizedBox(width: width * 0.9, child: Divider(color: AppColors.BLACK,)),
                ],
              );
            default:
              return const Center(child: CircularProgressIndicator(color: AppColors.BLACK,));
          }
        }
    ));
  }
}
