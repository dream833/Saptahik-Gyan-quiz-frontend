import 'dart:async';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NointernetController extends GetxController {
  var isConnected = true.obs;
  var isRetrying = false.obs;

  late StreamSubscription _subscription;

  @override
  void onInit() {
    super.onInit();

    // Listen to connectivity changes (wifi/mobile)
    _subscription = Connectivity().onConnectivityChanged.listen((_) async {
      final hasInternet = await InternetConnectionChecker().hasConnection;
      isConnected.value = hasInternet;
    });

    checkConnection();
  }

  Future<void> checkConnection() async {
    final hasInternet = await InternetConnectionChecker().hasConnection;
    isConnected.value = hasInternet;
  }

  Future<void> retry() async {
    isRetrying.value = true;
    await checkConnection();
    await Future.delayed(const Duration(milliseconds: 800));
    isRetrying.value = false;
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
