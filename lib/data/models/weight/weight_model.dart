import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class WeightModel extends Equatable {
  final String weight;
  final DateTime date;

  const WeightModel({required this.weight, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'weight': weight,
      'date': date,
    };
  }

  factory WeightModel.fromSnap(
      QueryDocumentSnapshot<Map<String, dynamic>> snap) {
    return WeightModel(
      weight: snap['weight'],
      date: snap['date'].toDate(),
    );
  }

  @override
  List<Object?> get props => [weight, date];
}
