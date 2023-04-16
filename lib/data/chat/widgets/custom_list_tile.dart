import 'package:Aap_job/utill/colors.dart';
import 'package:flutter/material.dart';


class CustomListTile extends StatelessWidget {
  const CustomListTile({
    super.key,
    required this.title,
    required this.leading,
    this.subTitle,
    this.trailing,
  });

  final String title;
  final IconData leading;
  final String? subTitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      contentPadding: const EdgeInsets.fromLTRB(25, 5, 10, 5),
      title: Text(title),
      subtitle: subTitle != null
          ? Text(
              subTitle!,
              style: TextStyle(
                color: greyColor,
              ),
            )
          : null,
      leading: Icon(leading),
      trailing: trailing,
    );
  }
}
