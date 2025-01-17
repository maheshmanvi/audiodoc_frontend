import 'package:audiodoc/infrastructure/app_state.dart';
import 'package:audiodoc/infrastructure/sl.dart';
import 'package:audiodoc/ui/pages/_notes/notes_view.dart';
import 'package:audiodoc/ui/pages/home/home_page_view.dart';
import 'package:audiodoc/ui/pages/login/login_view.dart';
import 'package:audiodoc/ui/pages/new_note/new_note_view.dart';
import 'package:audiodoc/ui/pages/view_note/view_note_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {
  static const String login = "/login";
  static const String nameLogin = "login";

  static const String notesHome = "/notes/home";
  static const String nameNotesHome = "notesHome";

  static const String newNote = "/notes/new";
  static const String nameNewNote = "newNote";

  static const String viewNoteById = "/notes/:id";
  static const String nameViewNoteById = "noteById";
}

final rootNavigatorKey = GlobalKey<NavigatorState>();
final notesNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: AppRoutes.notesHome,
  routes: [
    ShellRoute(
      navigatorKey: notesNavigatorKey,
      builder: (context, state, child) {
        return NotesView(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoutes.notesHome,
          name: AppRoutes.nameNotesHome,
          pageBuilder: (context, state) => NoTransitionPage(child: HomePageView()),
        ),
        GoRoute(
          path: AppRoutes.newNote,
          name: AppRoutes.nameNewNote,
          pageBuilder: (context, state) => NoTransitionPage(child: NewNoteView(routerState: state)),
        ),
        GoRoute(
          path: AppRoutes.viewNoteById,
          name: AppRoutes.nameViewNoteById,
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return NoTransitionPage(child: ViewNoteView(id: id));
          },
        ),
      ],
    ),
    GoRoute(
      name: AppRoutes.nameLogin,
      path: AppRoutes.login,
      pageBuilder: (context, state) => NoTransitionPage(child: LoginView()),
    ),
  ],
  redirect: (ctx, state) async {
    AppState appState = sl();
    if (appState.isLoggedIn) {
      return null;
    }
    return AppRoutes.login;
  },
);
