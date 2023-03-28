import 'package:flutter/material.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

const _avatarSize = 30.0;

class Avatar extends StatelessWidget {
  const Avatar({super.key, this.photo});

  final String? photo;

  @override
  Widget build(BuildContext context) {
    final photo = this.photo;
    return CircleAvatar(
      radius: _avatarSize,
      backgroundImage: photo != null ? NetworkImage(photo) : null,
      child: photo == null
          ? const Icon(Icons.person_outline, size: _avatarSize, color: AppColors.GREY)
          : null,
    );
  }
}