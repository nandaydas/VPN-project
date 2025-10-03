import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/location_controller.dart';
import '../main.dart';
import 'widgets/vpn_card.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen({super.key});

  // Use Get.find() or initialize within the build method if not using dependency injection.
  // Assuming LocationController is already registered with Get.put() or Get.lazyPut()
  final _controller = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    // Call getVpnData only if the list is empty and it hasn't been called yet (to prevent multiple calls on rebuilds if not handled in controller)
    // A better practice is to call this in the controller's onInit method.
    // We'll keep the check here for now but move the core logic to the controller.
    // if (_controller.vpnList.isEmpty) _controller.getVpnData();

    // Check if data should be fetched when the screen opens (assuming a proper setup in LocationController)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.vpnList.isEmpty && !_controller.isLoading.value) {
        _controller.getVpnData();
      }
    });


    return Obx(
      () => Scaffold(
        appBar: AppBar(
          // Use an expressive title with bold text and a subtle color contrast
          title: Text(
            'Available Servers',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white, // White title for better contrast
            ),
          ),
          backgroundColor: Colors.blueGrey.shade800, // Darker, professional AppBar
          iconTheme: const IconThemeData(color: Colors.white), // White icons
          elevation: 0, // Flat design
          actions: [
            // Display the current count in the action area
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  '${_controller.vpnList.length} Found',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
        // Use a background color for a more polished look
        backgroundColor: Colors.grey.shade100,
        
        // Floating action button for refreshing
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _controller.getVpnData(),
          label: const Text('Refresh', style: TextStyle(fontWeight: FontWeight.bold)),
          icon: const Icon(CupertinoIcons.refresh_circle_fill),
          backgroundColor: Colors.teal.shade500, // Vibrant button color
          foregroundColor: Colors.white,
        ),
        
        body: SafeArea(
          child: _controller.isLoading.value
              ? _loadingWidget()
              : _controller.vpnList.isEmpty
                  ? _noVPNFound()
                  : _vpnData(),
        ),
      ),
    );
  }

  // --- WIDGETS ---

  // Refactored VPN Data list with improved padding and style
  Widget _vpnData() => ListView.builder(
      itemCount: _controller.vpnList.length,
      padding: EdgeInsets.only(
          top: mq.height * .02,
          bottom: mq.height * .1 + 70, // Added space for FAB
          left: mq.width * .04,
          right: mq.width * .04),
      itemBuilder: (ctx, i) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0), // Space between cards
            child: VpnCard(vpn: _controller.vpnList[i]),
          ));

  // Modernized Loading Widget
  Widget _loadingWidget() => SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Colors.teal, // Use the app's accent color
            ),
            SizedBox(height: mq.height * .02),
            Text(
              'Fetching Secure Servers...',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueGrey.shade700,
                  fontWeight: FontWeight.w600),
            )
          ],
        ),
      );

  // Improved No VPN Found message
  Widget _noVPNFound() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // A relevant icon to indicate no data
            Icon(
              CupertinoIcons.antenna_radiowaves_
                  , // Or another relevant icon like globe or network
              size: 80,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: mq.height * .02),
            Text(
              'No Servers Found!',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: mq.height * .01),
            Text(
              'Tap "Refresh" to try again.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
}
