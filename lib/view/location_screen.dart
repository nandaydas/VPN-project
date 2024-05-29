import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/location_controller.dart';
import '../main.dart';
import 'widgets/vpn_card.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen({super.key});

  final _controller = LocationController();

  @override
  Widget build(BuildContext context) {
    if (_controller.vpnList.isEmpty) _controller.getVpnData();

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text('Free Locations (${_controller.vpnList.length})'),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10, right: 10),
          child: FloatingActionButton(
              backgroundColor: Colors.green.shade800,
              onPressed: () => _controller.getVpnData(),
              child: Icon(CupertinoIcons.refresh)),
        ),
        body: _controller.isLoading.value
            ? _loadingWidget()
            : _controller.vpnList.isEmpty
                ? _noVPNFound()
                : _vpnData(),
      ),
    );
  }

  _vpnData() => ListView.builder(
      itemCount: _controller.vpnList.length,
      padding: EdgeInsets.only(
          top: mq.height * .015,
          bottom: mq.height * .1,
          left: mq.width * .04,
          right: mq.width * .04),
      itemBuilder: (ctx, i) => VpnCard(vpn: _controller.vpnList[i]));

  _loadingWidget() => SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            Text(
              'Loading Servers...',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      );

  _noVPNFound() => Center(
        child: Text(
          'Not Servers Found!',
          style: TextStyle(
              fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold),
        ),
      );
}
