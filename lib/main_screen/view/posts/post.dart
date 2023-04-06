import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:posts_repository/posts_repository.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';
import 'package:zupa_na_pietrynie/app/app.dart';
import 'package:zupa_na_pietrynie/home/home.dart';
import 'package:zupa_na_pietrynie/main_screen/main_screen.dart';


class SinglePost extends StatefulWidget {
  const SinglePost({Key? key, required Post this.post, required Set<UserToPost> this.usersToPosts, required bool this.isAdmin}) : super(key: key);

  final Post post;
  final Set<UserToPost> usersToPosts;
  final bool isAdmin;

  @override
  State<SinglePost> createState() => _SinglePostState(post, usersToPosts, isAdmin);
}

class _SinglePostState extends State<SinglePost> {

  final Post post;
  final Set<UserToPost> usersToPosts;
  final bool isAdmin;
  bool isCommentsShowed = false;

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
    return "Usunięty użytkownik" + "\n" + date.substring(0, 16);
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
            BoxShadow(
                color: AppColors.GREY,
                blurRadius: 10,
                spreadRadius: 1)
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
                      photo: chooseAvatar(
                          post.ownerId,
                          usersToPosts)),
                ),
                const SizedBox(width: 10),
                Text(chooseNameAndDate(
                    post.ownerId,
                    usersToPosts,
                    post
                        .creationDate)!),
                Spacer(),
                if (isAdmin == true ||
                    user.id ==
                        post.ownerId)
                  EditButton(post: post),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const SizedBox(width: 15),
                Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                      width: width * 0.86,
                      child: Text(post
                          .postContent)),
                )
              ],
            ),
            if (post!.postPhotos
                ?.length !=
                0)
              SizedBox(height: 15),
            if (post!.postPhotos
                ?.length !=
                0)
              SizedBox(
                height: 10,
              ),
            if (post!.postPhotos
                ?.length !=
                0)
              Container(
                  height: 300,
                  child: ListView.separated(
                      scrollDirection:
                      Axis.horizontal,
                      // physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder:
                          (context, ind) =>
                          SizedBox(
                            width: 20,
                          ),
                      shrinkWrap: true,
                      itemCount: post
                          .postPhotos!.length,
                      itemBuilder:
                          (BuildContext context,
                          int indexex) {
                        return Container(
                          // height: 60,
                          child: Image(
                              image: NetworkImage(post
                                  .postPhotos![
                              indexex])),
                        );
                      })),
            const SizedBox(height: 20),
            Row(
              children: [
                Spacer(),
                if (post.numberOfComments == 0) Text("Komentarze: " + post.numberOfComments.toString()),
                if (post.numberOfComments != 0) TextButton(onPressed: ()=>{
                  if (isCommentsShowed == false) {
                    context.read<MainScreenBloc>().add(FetchComments(post.id!)),
                    isCommentsShowed = true
                  } else {
                    isCommentsShowed = false
                  },
                  setState(() {})
                }, child: Text("Komentarze: " + post.numberOfComments.toString())),
                if (post.numberOfComments == 0) const SizedBox(width: 18),
                if (post.numberOfComments != 0) const SizedBox(width: 8),
              ],
            ),
            if(isCommentsShowed) Container(color: AppColors.BLACK, height: 400,),
            if (post.numberOfComments == 0) const SizedBox(height: 20),
          ],
        ));
  }
}
