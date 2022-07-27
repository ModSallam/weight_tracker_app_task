import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weight_tracker_task_app/data/data.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepository _authRepository;

  SignUpCubit(this._authRepository) : super(SignUpState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SignUpStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SignUpStatus.initial));
  }

  Future<void> signUp() async {
    if (state.status == SignUpStatus.submitting) return;
    emit(state.copyWith(status: SignUpStatus.submitting));
    try {
      await _authRepository.signUp(
          email: state.email, password: state.password);
      emit(state.copyWith(status: SignUpStatus.success));
    } catch (_) {}
  }
}
