import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  const AppUser({required this.id, this.email, this.displayName});

  final String id;
  final String? email;
  final String? displayName;

  @override
  List<Object?> get props => [id, email, displayName];

  AppUser copyWith({String? id, String? email, String? displayName}) => AppUser(
        id: id ?? this.id,
        email: email ?? this.email,
        displayName: displayName ?? this.displayName,
      );
}

