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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'VPN Project',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 12),
            onPressed: () => Get.to(() => NetworkTestScreen()),
            icon: const Icon(CupertinoIcons.info, size: 26),
          ),
        ],
      ),
      drawer: MyDrawer(),
      bottomNavigationBar: _changeLocation(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const SizedBox(height: 20),

            // Power Button
            Obx(() => _vpnButton()),

            const SizedBox(height: 24),

            // IP & Ping
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  HomeCard(
                    title: _controller.vpn.value.countryLong.isEmpty
                        ? '--'
                        : _controller.vpn.value.ip,
                    subtitle: 'IP Address',
                    icon: const Icon(Icons.location_pin,
                        size: 30, color: Colors.blue),
                  ),
                  HomeCard(
                    title: _controller.vpn.value.countryLong.isEmpty
                        ? '--'
                        : '${_controller.vpn.value.ping} ms',
                    subtitle: 'Ping',
                    icon: const Icon(Icons.equalizer_rounded,
                        size: 30, color: Colors.purple),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Upload & Download Speeds
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    HomeCard(
                      title: snapshot.hasData ? downloadSpeed : '0 kbps',
                      subtitle: 'Download',
                      icon: const Icon(Icons.download_rounded,
                          size: 30, color: Colors.green),
                    ),
                    HomeCard(
                      title: snapshot.hasData ? uploadSpeed : '0 kbps',
                      subtitle: 'Upload',
                      icon: const Icon(Icons.upload_rounded,
                          size: 30, color: Colors.orange),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Modern Power Button
  Widget _vpnButton() => Column(
        children: [
          InkWell(
            onTap: () => _controller.connectToVpn(),
            borderRadius: BorderRadius.circular(100),
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    _controller.getButtonColor.withOpacity(.7),
                    _controller.getButtonColor
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _controller.getButtonColor.withOpacity(.4),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Container(
                width: mq.height * .16,
                height: mq.height * .16,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.power_settings_new,
                        size: 36, color: Colors.white),
                    const SizedBox(height: 8),
                    Text(
                      _controller.getButtonText,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // VPN Status Label
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            decoration: BoxDecoration(
              color: _controller.vpnState.value == VpnEngine.vpnConnected
                  ? Colors.green
                  : Colors.redAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _controller.vpnState.value == VpnEngine.vpnDisconnected
                  ? 'Not Connected'
                  : _controller.vpnState.replaceAll('_', ' ').toUpperCase(),
              style: const TextStyle(fontSize: 13, color: Colors.white),
            ),
          ),
          const SizedBox(height: 8),

          // Timer
          Obx(() => CountDownTimer(
              startTimer:
                  _controller.vpnState.value == VpnEngine.vpnConnected)),
        ],
      );

  /// Location Bottom Bar
  Widget _changeLocation(BuildContext context) => SafeArea(
        child: BottomAppBar(
          elevation: 8,
          color: Colors.white,
          child: InkWell(
            onTap: () => Get.to(() => LocationScreen()),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              height: 65,
              child: Obx(
                () => Row(
                  children: [
                    _controller.vpn.value.countryLong.isEmpty
                        ? Icon(Icons.public, color: Colors.green.shade800)
                        : Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                'assets/flags/${_controller.vpn.value.countryShort.toLowerCase()}.png',
                                height: 40,
                              ),
                            ),
                          ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _controller.vpn.value.countryShort.isEmpty
                              ? 'Select Country'
                              : _controller.vpn.value.countryShort,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          _controller.vpn.value.countryLong.isEmpty
                              ? 'Tap to choose a server'
                              : _controller.vpn.value.countryLong,
                          style: TextStyle(
                              fontSize: 13, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const Spacer(),
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
      );
}