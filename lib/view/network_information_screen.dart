import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../apis/apis.dart';
import '../main.dart';
import '../models/ip_details.dart';
import '../models/network_data.dart';
import 'widgets/network_card.dart'; // Keeping your custom card for now, but improving the layout

class NetworkTestScreen extends StatelessWidget {
  const NetworkTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize IPDetails as an observable to trigger UI updates
    final ipData = IPDetails.fromJson({}).obs;

    // Fetch data on screen load
    APIs.getIPDetails(ipData: ipData);

    // Helper function to handle the refresh logic
    void refreshData() {
      // Clear current data to show 'Fetching...' immediately
      ipData.value = IPDetails.fromJson({});
      // Fetch new data
      APIs.getIPDetails(ipData: ipData);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Information', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white, // Light background for AppBar
        elevation: 0.5, // Subtle shadow
      ),
      
      // Floating Action Button for Refresh
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10, right: 10),
        child: FloatingActionButton.extended(
          // Use Extended FAB for better user clarity
          onPressed: refreshData,
          backgroundColor: Colors.green.shade700,
          icon: const Icon(CupertinoIcons.refresh, size: 22),
          label: const Text('Refresh', style: TextStyle(fontSize: 16)),
        ),
      ),
      
      // Main Body
      body: Obx(
        () {
          // Check if the initial data fetch is still pending (e.g., query is empty)
          final isFetching = ipData.value.query.isEmpty && ipData.value.status != 'fail';

          return Padding(
            padding: EdgeInsets.only(
              left: mq.width * .04,
              right: mq.width * .04,
              top: mq.height * .01,
            ),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                // --- Top Banner/Header Card ---
                _buildHeaderCard(ipData.value, isFetching),
                
                SizedBox(height: mq.height * 0.02), // Separator
                
                const Text(
                  'Detailed Location Data',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                
                SizedBox(height: mq.height * 0.015),
                
                // --- Detailed Cards Grid/List ---
                // Using a Column for better spacing management than ListView's direct children
                Column(
                  children: [
                    _buildNetworkCard(
                      title: 'Internet Provider',
                      subtitle: ipData.value.isp,
                      icon: Icons.business_rounded,
                      color: Colors.pink,
                      isFetching: isFetching,
                    ),
                    _buildNetworkCard(
                      title: 'Location',
                      subtitle: ipData.value.country.isEmpty
                          ? 'Fetching ...'
                          : '${ipData.value.city}, ${ipData.value.regionName}, ${ipData.value.country}',
                      icon: Icons.map_rounded,
                      color: Colors.orange,
                      isFetching: isFetching,
                    ),
                    _buildNetworkCard(
                      title: 'Pin-code/ZIP',
                      subtitle: ipData.value.zip,
                      icon: Icons.markunread_mailbox_rounded,
                      color: Colors.teal,
                      isFetching: isFetching,
                    ),
                    _buildNetworkCard(
                      title: 'Timezone',
                      subtitle: ipData.value.timezone,
                      icon: Icons.schedule_rounded,
                      color: Colors.indigo,
                      isFetching: isFetching,
                    ),
                    
                    // Add padding to ensure the last item is visible above the FAB
                    SizedBox(height: mq.height * 0.15),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Widget for the Main IP Address Display ---
  Widget _buildHeaderCard(IPDetails data, bool isFetching) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(CupertinoIcons.location_solid, color: Colors.green.shade700, size: 30),
                const SizedBox(width: 10),
                const Text(
                  'Your IP Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              isFetching ? 'Fetching your current IP...' : data.query,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade800,
              ),
            ),
            if (!isFetching) ...[
              const Divider(height: 25),
              Text(
                'Latitude: ${data.lat} | Longitude: ${data.lon}',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ]
          ],
        ),
      ),
    );
  }

  // --- Widget for Detailed Information Cards ---
  Widget _buildNetworkCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isFetching,
  }) {
    // If fetching, subtitle should be 'Fetching ...'
    final displaySubtitle = (isFetching || subtitle.isEmpty) ? 'Fetching ...' : subtitle;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        subtitle: Text(
          displaySubtitle,
          style: TextStyle(
            fontSize: 15,
            fontWeight: displaySubtitle == 'Fetching ...' ? FontWeight.w500 : FontWeight.normal,
            color: displaySubtitle == 'Fetching ...' ? Colors.grey : Colors.black,
          ),
        ),
      ),
    );
  }
}

