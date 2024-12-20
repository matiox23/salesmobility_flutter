import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_app_users/blocs/blocs.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'dart:developer' as developer;

part 'internet_event.dart';
part 'internet_state.dart';

class InternetBloc extends Bloc<InternetEvent, InternetState> {
  InternetBloc() : super(InternetInitial()) {
    on<InternetEvent>(checkEmitEvent);

    InternetConnection.createInstance(
      customCheckOptions: [
        InternetCheckOption(
          uri: Uri.parse('https://clients3.google.com/generate_204'),
          timeout: const Duration(seconds: 2),
          headers: {'User-Agent': 'Android', 'Connection': 'close'},
          responseStatusFn: (response) {
            return response.statusCode == 204;
          },
        ),
      ],
      useDefaultOptions: false,
    ).onStatusChange.listen(
      (status) {
        developer.log('InternetBloc status: $status', name: 'my.app.developer');
        if (status == InternetStatus.connected) {
          add(ConnectedEvent());
        } else if (status == InternetStatus.disconnected) {
          add(NotConnectedEvent());
        }
      },
      onError: (error) {
        developer.log('InternetBloc Error: $error', name: 'my.app.developer');
        add(NotConnectedEvent());
      },
      cancelOnError: false,
    );
  }

  FutureOr<void> checkEmitEvent(event, emit) {
    if (event is ConnectedEvent) {
      emit(ConnectedState(message: 'Connected'));
    } else if (event is NotConnectedEvent) {
      emit(NotConnectedState(message: 'Disconnected.'));
    }
  }
}
