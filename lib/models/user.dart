import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String about;
  final String password;
  final String avatarUrl;

  const User(
      {required this.id,
      required this.name,
      required this.email,
      required this.about,
      required this.password,
      required this.avatarUrl});
}
