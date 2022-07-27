part of 'weight_cubit.dart';

enum WeightStatus { initial, submitting, success, error }

class WeightState extends Equatable {
  final String weight;
  final WeightStatus status;

  const WeightState({
    required this.weight,
    required this.status,
  });

  factory WeightState.initial() {
    return const WeightState(
      weight: '',
      status: WeightStatus.initial,
    );
  }

  WeightState copyWith({
    String? weight,
    WeightStatus? status,
  }) {
    return WeightState(
      weight: weight ?? this.weight,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [weight, status];
}
