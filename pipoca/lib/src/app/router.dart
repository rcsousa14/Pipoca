
import 'package:pipoca/src/views/auth_view/auth_view.dart';
import 'package:pipoca/src/views/login_view/login_view.dart';
import 'package:pipoca/src/views/main_view/main_view.dart';

import 'package:stacked/stacked_annotations.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: AuthView, initial: true),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: MainView),
  ]
)
class AppSetup {}
