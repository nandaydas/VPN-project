import 'package:flutter/material.dart';

import '../../main.dart';

//card to represent status in home screen
class HomeCard extends StatelessWidget {
  final String title, subtitle;
  final Widget icon;

  const HomeCard(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
   
          borderRadius: BorderRadius.circular(10),
          color: Colors.white),
      width: mq.width * .45,
      child: Row(
        children: [
          const SizedBox(width: 8),
          icon,
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subtitle,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}
