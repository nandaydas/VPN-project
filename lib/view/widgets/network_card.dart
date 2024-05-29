import 'package:flutter/material.dart';
import '../../main.dart';
import '../../models/network_data.dart';

class NetworkCard extends StatelessWidget {
  final NetworkData data;

  const NetworkCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: mq.height * .01),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(15),
        child: ListTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade800.withOpacity(0.2),
            child: Icon(data.icon.icon,
                color: Colors.green.shade800, size: data.icon.size ?? 28),
          ),
          title: Text(data.title),
          subtitle: Text(data.subtitle),
        ),
      ),
    );
  }
}
