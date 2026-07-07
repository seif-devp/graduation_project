import 'package:dio/dio.dart';
import 'package:graduation_project/core/services/snackbar_service.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 500) {
      SnackbarService.showErrorSnackbar('error in server try again later');
    }
    super.onError(err, handler);
  }
}
