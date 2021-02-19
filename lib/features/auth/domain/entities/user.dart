import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class User extends Equatable {
  final String id;
  final String email;

  User({
    this.id,
    @required this.email,
  }) : assert(email != null);

  @override
  List<Object> get props => [id];
}
