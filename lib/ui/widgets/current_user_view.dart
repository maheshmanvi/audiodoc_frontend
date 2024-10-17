import 'package:audiodoc/domain/usecases/auth_usecases.dart';
import 'package:audiodoc/infrastructure/app_state.dart';
import 'package:audiodoc/infrastructure/sl.dart';
import 'package:audiodoc/theme/theme_extension.dart';
import 'package:audiodoc/ui/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';
import 'package:go_router/go_router.dart';

class CurrentUserView extends StatefulWidget {
  const CurrentUserView({
    super.key,
  });

  @override
  State<CurrentUserView> createState() => _CurrentUserViewState();
}

class _CurrentUserViewState extends State<CurrentUserView> {
  final MenuController _menuController = MenuController();

  final AppState appState = sl();
  final AuthUseCases _authUseCases = sl();

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      alignmentOffset: Offset(4, 4),
      controller: _menuController,
      style: MenuStyle(
        elevation: WidgetStatePropertyAll(4),
        backgroundColor: WidgetStatePropertyAll(context.theme.colors.surface),
      ),
      menuChildren: [
        _ProfileView(name: appState.user.name, email: appState.user.email),
        Divider(color: context.theme.colors.divider, thickness: 1, height: 1),
        MenuItemButton(
          child: Row(
            children: [
              Text(
                'Logout',
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: context.theme.colors.error,
                ),
              ),
              const SizedBox(width: 8),
              Spacer(),
              Icon(Icons.logout, color: context.theme.colors.error, size: 18),
            ],
          ),
          onPressed: () {
            _menuController.close();
            _logout();
          },
        )
      ],
      child: InkWell(
        onTap: _toggleMenu,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: context.theme.colors.accent,
              child: Text(
                appState.user.name.characters.first.toUpperCase(),
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: context.theme.colors.onAccent,
                  fontWeight: context.theme.typo.fw.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _toggleMenu() {
    if (_menuController.isOpen) {
      _menuController.close();
    } else {
      _menuController.open();
    }
  }

  void _logout() async {
    await _authUseCases.logout();
    context.goNamed(AppRoutes.nameLogin);
  }
}

class _ProfileView extends StatelessWidget {
  final String name;
  final String email;

  const _ProfileView({
    super.key,
    required this.name,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: context.theme.colors.accent,
            child: Text(
              name.characters.first.toUpperCase(),
              style: context.theme.textTheme.bodyMedium?.copyWith(
                color: context.theme.colors.onAccent,
                fontWeight: context.theme.typo.fw.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: context.theme.textTheme.bodyMedium?.copyWith(
                    color: context.theme.colors.contentPrimary,
                    fontWeight: context.theme.typo.fw.medium,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: context.theme.textTheme.bodySmall?.copyWith(
                    color: context.theme.colors.contentSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
