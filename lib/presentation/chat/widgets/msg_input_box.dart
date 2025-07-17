import 'package:chat_app/core/theme/colors.dart';
import 'package:flutter/material.dart';

class MsgInputBox extends StatelessWidget {
  const MsgInputBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      color: AppPallete.appBarColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: Icon(
                  Icons.camera_alt,
                  size: 28,
                )),
            IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                icon: Icon(
                  Icons.attach_file,
                  size: 28,
                )),
            Expanded(
              child: TextField(
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                    fillColor: AppPallete.backgroundColor2,
                    filled: true,
                    hintText: 'Type a message',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15)),
              ),
            ),
            const SizedBox(width: 5),
            CircleAvatar(
              radius: 25,
              backgroundColor: AppPallete.gradient4,
              child: Icon(
                Icons.send_rounded,
                size: 30,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
