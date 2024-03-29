import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:posts_repository/posts_repository.dart';

import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/app/app.dart';
import 'package:zupa_na_pietrynie/home/home.dart';
import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';

class SinglePost extends StatefulWidget {
  const SinglePost(
      {Key? key,
      required Post this.post,
      required Set<UserToPost> this.usersToPosts,
      required bool this.isAdmin})
      : super(key: key);

  final Post post;
  final Set<UserToPost> usersToPosts;
  final bool isAdmin;

  @override
  State<SinglePost> createState() =>
      _SinglePostState(post, usersToPosts, isAdmin);
}

class _SinglePostState extends State<SinglePost> {
  final Post post;
  final Set<UserToPost> usersToPosts;
  final bool isAdmin;
  bool isCommentsShowed = false;
  TextEditingController msgController = TextEditingController();

  _SinglePostState(this.post, this.usersToPosts, this.isAdmin);

  static String? chooseAvatar(String ownerId, Set<UserToPost> usersToPosts) {
    for (UserToPost user in usersToPosts) {
      if (ownerId == user.id) {
        return user.photo;
      }
    }
    return null;
  }

  static String? chooseNameAndDate(
      String ownerId, Set<UserToPost> usersToPosts, String date) {
    for (UserToPost user in usersToPosts) {
      if (ownerId == user.id) {
        return user.name + "\n" + date.substring(0, 16);
      }
    }
    return MainScreenStrings.DELETED_USER + "\n" + date.substring(0, 16);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final User user = context.select((AppBloc bloc) => bloc.state.user);
    return Container(
        decoration: BoxDecoration(
          color: AppColors.WHITE,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: AppColors.GREY, blurRadius: 10, offset: Offset(
              0,
              1,
            ),)
          ],
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 15),
                SizedBox(
                  width: 40,
                  height: 40,
                  child: Avatar(
                      avatarSize: 38,
                      photo: chooseAvatar(post.ownerId, usersToPosts)),
                ),
                const SizedBox(width: 10),
                Text(chooseNameAndDate(
                    post.ownerId, usersToPosts, post.creationDate)!),
                Spacer(),
                if (isAdmin == true || user.id == post.ownerId)
                  EditButton(post: post)
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 15),
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                      width: width * 0.86, child: Text(post.postContent)),
                )
              ],
            ),
            if (post!.postPhotos?.length != 0) SizedBox(height: 15),
            if (post!.postPhotos?.length != 0)
              SizedBox(
                height: 10,
              ),
            if (post!.postPhotos?.length != 0)
              Container(
                  height: 300,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      // physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, separatorInt) => SizedBox(
                            width: 20,
                          ),
                      shrinkWrap: true,
                      itemCount: post.postPhotos!.length,
                      itemBuilder: (BuildContext context, int photoIndex) {
                        return Container(
                          // height: 60,
                          child: Image(
                              image:
                                  NetworkImage(post.postPhotos![photoIndex])),
                        );
                      })),
            const SizedBox(height: 20),
            Row(
              children: [
                Spacer(),
                if (post.numberOfComments == 0)
                  Text(MainScreenStrings.COMMENTS +
                      post.numberOfComments.toString()),
                if (post.numberOfComments != 0)
                  TextButton(
                      onPressed: () => {
                            if (isCommentsShowed == false)
                              {
                                context
                                    .read<MainScreenBloc>()
                                    .add(CommentsFetch(post.id!)),
                                isCommentsShowed = true
                              }
                            else
                              {isCommentsShowed = false},
                            setState(() {})
                          },
                      child: Text(
                        MainScreenStrings.COMMENTS +
                            post.numberOfComments.toString(),
                        style: TextStyle(color: AppColors.BLACK),
                      )),
                if (post.numberOfComments == 0) const SizedBox(width: 18),
                if (post.numberOfComments != 0) const SizedBox(width: 8),
              ],
            ),
            if (isCommentsShowed) Comments(postId: post.id!, isAdmin: isAdmin),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                SizedBox(
                  width: width * 0.7,
                  // height: 40,
                  child: TextField(
                    controller: msgController,
                    cursorColor: AppColors.BLACK,
                    style: TextStyle(fontSize: 15),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.BLACK),
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          gapPadding: 1),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(color: AppColors.BLACK)),
                      hintText: MainScreenStrings.ADD_COMMENT,
                    ),
                  ),
                ),
                Spacer(),
                IconButton(
                  icon: const Icon(IconData(0xe571,
                      fontFamily: 'MaterialIcons', matchTextDirection: true)),
                  tooltip: MainScreenStrings.ADD_COMMENT,
                  onPressed: () {
                    if (3 <= msgController.value.text.length) {
                      context.read<MainScreenBloc>().add(
                          CommentCreate(msgController.value.text, post.id!));
                      msgController.clear();
                    }
                  },
                ),
                const SizedBox(width: 20),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ));
  }
}
