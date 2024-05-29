import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/view/widgets/my_drawer.dart';
import '../controllers/home_controller.dart';
import '../main.dart';
import '../models/vpn_status.dart';
import '../services/vpn_engine.dart';
import 'widgets/count_down_timer.dart';
import 'widgets/home_card.dart';
import 'location_screen.dart';
import 'network_information_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    VpnEngine.vpnStageSnapshot().listen((event) {
      _controller.vpnState.value = event;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('VPN Project'),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 8),
            onPressed: () => Get.to(() => NetworkTestScreen()),
            icon: Icon(
              CupertinoIcons.info,
              size: 27,
            ),
          ),
        ],
      ),
      drawer: MyDrawer(),
      bottomNavigationBar: _changeLocation(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Obx(() => _vpnButton()),
          Column(
            children: [
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HomeCard(
                      title: _controller.vpn.value.countryLong.isEmpty
                          ? '100 ms'
                          : '${_controller.vpn.value.ip}',
                      subtitle: 'IP',
                      icon: Icon(Icons.location_pin,
                          size: 30, color: Colors.blue),
                    ),
                    HomeCard(
                      title: _controller.vpn.value.countryLong.isEmpty
                          ? '100 ms'
                          : '${_controller.vpn.value.ping} ms',
                      subtitle: 'PING',
                      icon: Icon(Icons.equalizer_rounded,
                          size: 30, color: Colors.purple),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              StreamBuilder<VpnStatus?>(
                initialData: VpnStatus(),
                stream: VpnEngine.vpnStatusSnapshot(),
                builder: (context, snapshot) {
                  final byteIn = snapshot.data?.byteIn ?? '0 Kbps';
                  final byteOut = snapshot.data?.byteOut ?? '0 Kbps';

                  final downloadSpeed = byteIn.split(' - ').isNotEmpty
                      ? byteIn.split(' - ')[0].replaceAll('↓', '')
                      : '0 Kbps';
                  final uploadSpeed = byteOut.split(' - ').isNotEmpty
                      ? byteOut.split(' - ')[0].replaceAll('↑', '')
                      : '0 Kbps';

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      HomeCard(
                        title: snapshot.hasData ? downloadSpeed : '0 kbps',
                        subtitle: 'DOWNLOAD',
                        icon: Icon(Icons.download_rounded,
                            size: 30, color: Colors.green),
                      ),
                      HomeCard(
                        title: snapshot.hasData ? uploadSpeed : '0 kbps',
                        subtitle: 'UPLOAD',
                        icon: Icon(Icons.upload_rounded,
                            size: 30, color: Colors.orange),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _vpnButton() => Column(
        children: [
          Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                _controller.connectToVpn();
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _controller.getButtonColor.withOpacity(.1)),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _controller.getButtonColor.withOpacity(.3)),
                  child: Container(
                    width: mq.height * .14,
                    height: mq.height * .14,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _controller.getButtonColor),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.power_settings_new,
                          size: 28,
                          color: Colors.white,
                        ),
                        SizedBox(height: 4),
                        Text(
                          _controller.getButtonText,
                          style: TextStyle(
                              fontSize: 12.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: mq.height * .015, bottom: mq.height * .02),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(15)),
            child: Text(
              _controller.vpnState.value == VpnEngine.vpnDisconnected
                  ? 'Not Connected'
                  : _controller.vpnState.replaceAll('_', ' ').toUpperCase(),
              style: TextStyle(fontSize: 12.5, color: Colors.white),
            ),
          ),
          Obx(() => CountDownTimer(
              startTimer:
                  _controller.vpnState.value == VpnEngine.vpnConnected)),
        ],
      );

  Widget _changeLocation(BuildContext context) => SafeArea(
        child: BottomAppBar(
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: () => Get.to(() => LocationScreen()),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: mq.width * .04),
                color: Colors.white,
                height: 60,
                child: Obx(
                  () => Row(
                    children: [
                      _controller.vpn.value.countryLong.isEmpty
                          ? Icon(
                              Icons.public,
                              color: Colors.green.shade800,
                            )
                          : Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  'assets/flags/${_controller.vpn.value.countryShort.toLowerCase()}.png',
                                  height: 40,
                                ),
                              ),
                            ),
                      SizedBox(width: 10),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _controller.vpn.value.countryShort.isEmpty
                                ? 'Country'
                                : _controller.vpn.value.countryShort,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            _controller.vpn.value.countryLong.isEmpty
                                ? 'Country'
                                : _controller.vpn.value.countryLong,
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          Text(
                            'Change',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade800),
                          ),
                          Icon(Icons.arrow_forward_ios_rounded,
                              color: Colors.green.shade800, size: 18),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
