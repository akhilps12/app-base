import 'package:dartz/dartz.dart';
import 'package:flutter_application_1/application/core/utils/logger.dart';
import 'package:flutter_application_1/application/core/utils/typedefs.dart';
import 'package:flutter_application_1/domain/core/exception/custom_exception.dart';
import 'package:flutter_application_1/domain/core/failures/failures.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class RunSafely {
  RunSafely();

  ResultFuture<T> runSafely<T>(
    Future<T> Function() action, {
    MainFailure Function(String error)? failure,
  }) async {
    try {
      return right(await action());
    } on CustomException catch (e) {
      Logger.logError('RunSafely Error : $e');
      return left(
        failure?.call(e.errMsg) ??
            MainFailure.customError(
              errorMsg: e.errMsg,
            ),
      );
    } catch (e) {
      Logger.logError('RunSafely Error : $e');
      return left(
        failure?.call(
              e.toString(),
            ) ??
            MainFailure.genericError(
              errorMsg: e.toString(),
            ),
      );
    }
  }
}
