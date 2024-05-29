import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../apis/apis.dart';
import '../main.dart';
import '../models/ip_details.dart';
import '../models/network_data.dart';
import 'widgets/network_card.dart';

class NetworkTestScreen extends StatelessWidget {
  const NetworkTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ipData = IPDetails.fromJson({}).obs;
    APIs.getIPDetails(ipData: ipData);

    return Scaffold(
      appBar: AppBar(title: Text('Network Information')),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10),
        child: FloatingActionButton(
          backgroundColor: Colors.green.shade800,
          onPressed: () {
            ipData.value = IPDetails.fromJson({});
            APIs.getIPDetails(ipData: ipData);
          },
          child: Icon(CupertinoIcons.refresh),
        ),
      ),
      body: Obx(
        () => ListView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.only(
                left: mq.width * .04,
                right: mq.width * .04,
                top: mq.height * .01,
                bottom: mq.height * .1),
            children: [
              NetworkCard(
                data: NetworkData(
                    title: 'IP Address',
                    subtitle: ipData.value.query,
                    icon: Icon(CupertinoIcons.location_solid,
                        color: Colors.blue)),
              ),
              NetworkCard(
                data: NetworkData(
                    title: 'Internet Provider',
                    subtitle: ipData.value.isp,
                    icon: Icon(Icons.wifi_rounded)),
              ),
              NetworkCard(
                data: NetworkData(
                    title: 'Location',
                    subtitle: ipData.value.country.isEmpty
                        ? 'Fetching ...'
                        : '${ipData.value.city}, ${ipData.value.regionName}, ${ipData.value.country}',
                    icon: Icon(Icons.map_rounded)),
              ),
              NetworkCard(
                data: NetworkData(
                    title: 'Pin-code',
                    subtitle: ipData.value.zip,
                    icon: Icon(Icons.emoji_flags_rounded)),
              ),
              NetworkCard(
                data: NetworkData(
                    title: 'Timezone',
                    subtitle: ipData.value.timezone,
                    icon: Icon(Icons.schedule_rounded)),
              ),
            ]),
      ),
    );
  }
}
