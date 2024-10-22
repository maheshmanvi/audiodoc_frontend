import 'package:audiodoc/domain/usecases/auth_usecases.dart';
import 'package:audiodoc/infrastructure/di.dart';
import 'package:audiodoc/infrastructure/env.dart';
import 'package:audiodoc/ui/app_view.dart';
import 'package:flutter/material.dart';

import 'infrastructure/sl.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Env.live();

  inject();

  final AuthUseCases authUseCases = sl();

  final authResult = await authUseCases.softLogin();
  if (authResult.isRight) await authUseCases.onAuthSuccess(authResult.right);

  runApp(AppView());

}
