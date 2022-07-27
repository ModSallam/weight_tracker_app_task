import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weight_tracker_task_app/data/data.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final AuthRepository _authRepository;
  StreamSubscription<UserModel>? _userSubscription;

  AppBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(
          authRepository.currentUser.isNotEmpty
              ? AppState.authenticated(authRepository.currentUser)
              : const AppState.unauthenticated(),
        ) {
    on<AppUserChanged>(_onAppUserChanged);
    on<AppSignOutRequested>(_onAppSignOutRequested);

    _userSubscription = _authRepository.user.listen(
      (user) => add(
        AppUserChanged(user),
      ),
    );
  }

  void _onAppUserChanged(
    AppUserChanged event,
    Emitter<AppState> emit,
  ) {
    emit(
      event.user.isNotEmpty
          ? AppState.authenticated(event.user)
          : const AppState.unauthenticated(),
    );
  }

  void _onAppSignOutRequested(
    AppSignOutRequested event,
    Emitter<AppState> emit,
  ) {
    unawaited(_authRepository.signOut());
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
