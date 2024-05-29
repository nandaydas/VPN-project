import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/vpn_status.dart';
import '../models/vpn_config.dart';

class VpnEngine {
  static final String _eventChannelVpnStage = "vpnStage";
  static final String _eventChannelVpnStatus = "vpnStatus";
  static final String _methodChannelVpnControl = "vpnControl";

  static Stream<String> vpnStageSnapshot() =>
      EventChannel(_eventChannelVpnStage).receiveBroadcastStream().cast();

  static Stream<VpnStatus?> vpnStatusSnapshot() =>
      EventChannel(_eventChannelVpnStatus)
          .receiveBroadcastStream()
          .map((event) => VpnStatus.fromJson(jsonDecode(event)))
          .cast();

  static Future<void> startVpn(VpnConfig vpnConfig) async {
    return MethodChannel(_methodChannelVpnControl).invokeMethod(
      "start",
      {
        "config": vpnConfig.config,
        "country": vpnConfig.country,
        "username": vpnConfig.username,
        "password": vpnConfig.password,
      },
    );
  }

  static Future<void> stopVpn() =>
      MethodChannel(_methodChannelVpnControl).invokeMethod("stop");

  static Future<void> openKillSwitch() =>
      MethodChannel(_methodChannelVpnControl).invokeMethod("kill_switch");

  static Future<void> refreshStage() =>
      MethodChannel(_methodChannelVpnControl).invokeMethod("refresh");

  static Future<String?> stage() =>
      MethodChannel(_methodChannelVpnControl).invokeMethod("stage");

  static Future<bool> isConnected() =>
      stage().then((value) => value?.toLowerCase() == "connected");

  static const String vpnConnected = "connected";
  static const String vpnDisconnected = "disconnected";
  static const String vpnWaitConnection = "wait_connection";
  static const String vpnAuthenticating = "authenticating";
  static const String vpnReconnect = "reconnect";
  static const String vpnNoConnection = "no_connection";
  static const String vpnConnecting = "connecting";
  static const String vpnPrepare = "prepare";
  static const String vpnDenied = "denied";
}
