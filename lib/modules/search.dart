import 'package:flutter/material.dart';
import 'package:socialmedia_app/shared/styles/icon_broken.dart';

class Search_Screen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search',style: TextStyle(fontFamily: 'Shitman'),),centerTitle: true,leading: IconButton(onPressed: () { Navigator.pop(context); },
        icon: Icon(IconBroken.Arrow___Left_2),
      ),),
      body: Column(
        children: [
          Text('Search'),
        ],
      ),
    );
  }
}
