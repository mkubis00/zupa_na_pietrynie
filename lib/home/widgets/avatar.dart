import 'package:flutter/material.dart';
import 'package:zupa_na_pietrynie/content_holder/content_holder.dart';

class Avatar extends StatelessWidget {
  const Avatar({super.key, this.photo, required this.avatarSize});

  final String? photo;
  final double avatarSize;

  @override
  Widget build(BuildContext context) {
    final photo = this.photo;
    return CircleAvatar(
      radius: avatarSize,
      backgroundImage: photo != null ? NetworkImage(photo) : null,
      child: photo == null
          ? const Icon(Icons.person_outline, size: 20, color: AppColors.GREY)
          : null,
    );
  }
}