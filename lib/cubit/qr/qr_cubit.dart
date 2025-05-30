import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/cubit/qr/qr_state.dart';
import 'package:my_project/domain/services/usb_manager.dart';

class QRCubit extends Cubit<QRState> {
  final UsbManager usbManager;

  QRCubit({required this.usbManager}) : super(QRInitial());

  void processScannedQR(String data) {
    emit(QRSuccess(data));
  }

  Future<void> scanFromArduino() async {
    emit(QRLoading());
    try {
      await usbManager.dispose();

      final port = await usbManager.selectDevice();
      if (port == null) {
        emit(QRFailure('Порт не знайдено'));
        return;
      }

      String response = '';
      final completer = Completer<String>();
      StreamSubscription<Uint8List>? subscription;

      subscription = port.inputStream!.listen(
        (bytes) {
          response += String.fromCharCodes(bytes);
          if (response.contains('\n')) {
            subscription?.cancel();
            completer.complete(response.trim());
          }
        },
        onError: (Object e) {
          subscription?.cancel();
          if (!completer.isCompleted) {
            completer.completeError('Помилка читання з Arduino: ${e.toString()}');
          }
        },
        onDone: () {
          if (!completer.isCompleted) {
            completer.completeError('З\'єднання з Arduino закрито перед отриманням даних.');
          }
        },
      );

      final result = await completer.future.timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          subscription?.cancel();
          return 'Arduino не відповів (тайм-аут)';
        },
      );

      emit(QRSuccess(result));
    } catch (e) {
      emit(QRFailure(e.toString()));
    }
  }
}
