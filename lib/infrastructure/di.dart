import 'package:audiodoc/data/datasource/api_client.dart';
import 'package:audiodoc/data/repo/i_auth_repo.dart';
import 'package:audiodoc/data/repo/i_note_repo.dart';
import 'package:audiodoc/domain/repo/auth_repo.dart';
import 'package:audiodoc/domain/repo/note_repo.dart';
import 'package:audiodoc/domain/usecases/auth_usecases.dart';
import 'package:audiodoc/domain/usecases/note_usecases.dart';
import 'package:audiodoc/infrastructure/app_state.dart';
import 'package:audiodoc/infrastructure/sl.dart';

void inject() {
  sl.registerSingleton<AppState>(AppState());
  sl.registerSingleton<ApiClient>(ApiClient());
  sl.registerSingleton<AuthRepo>(IAuthRepo(apiClient: sl()));
  sl.registerSingleton<AuthUseCases>(AuthUseCases(authRepo: sl()));
  sl.registerSingleton<NoteRepo>(INoteRepo(apiClient: sl()));
  sl.registerSingleton(NoteUseCases(noteRepo: sl()));
}
