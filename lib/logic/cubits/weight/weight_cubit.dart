import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weight_tracker_task_app/data/data.dart';

part 'weight_state.dart';

class WeightCubit extends Cubit<WeightState> {
  final WeightRepository _weightRepository;

  WeightCubit(this._weightRepository) : super(WeightState.initial());

  void weightChanged(String value) {
    emit(state.copyWith(weight: value, status: WeightStatus.initial));
  }

  Future<void> addWeight() async {
    if (state.status == WeightStatus.submitting) return;
    emit(state.copyWith(status: WeightStatus.submitting));
    try {
      await _weightRepository.addWeight(
        weight: WeightModel(
          weight: state.weight,
          date: DateTime.now(),
        ),
      );
      emit(state.copyWith(status: WeightStatus.success));
    } catch (_) {}
  }
}
