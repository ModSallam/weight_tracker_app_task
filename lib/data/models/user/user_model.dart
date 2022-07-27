import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String? email;

  const UserModel({required this.id, this.email});

  static const empty = UserModel(id: '');

  bool get isEmpty => this == UserModel.empty;
  bool get isNotEmpty => this != UserModel.empty;

  @override
  List<Object?> get props => [id, email];
}
