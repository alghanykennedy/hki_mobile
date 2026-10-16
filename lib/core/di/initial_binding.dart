import 'package:get/get.dart';

import '../constants/app_strings.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../routes/app_routes.dart';
import '../services/connectivity_service.dart';
import '../services/token_storage.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Core Services
    final tokenStorage = TokenStorage();
    Get.put<TokenStorage>(tokenStorage, permanent: true);

    final networkInfo = NetworkInfoImpl();
    Get.put<NetworkInfo>(networkInfo, permanent: true);

    final connectivityService = ConnectivityService(networkInfo: networkInfo);
    Get.put<ConnectivityService>(connectivityService, permanent: true);

    // DioClient with 401 onSessionExpired callback
    final dioClient = DioClient(
      networkInfo: networkInfo,
      tokenStorage: tokenStorage,
      onSessionExpired: () async {
        if (Get.currentRoute != Routes.login) {
          Get.offAllNamed(Routes.login);
          Get.snackbar(
            AppStrings.error,
            AppStrings.unauthorizedMessage,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
    );
    Get.put<DioClient>(dioClient, permanent: true);
  }
}
