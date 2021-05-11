
import 'package:pipoca/src/views/auth_view/auth_view.dart';
import 'package:pipoca/src/views/login_view/login_view.dart';
import 'package:pipoca/src/views/main_view/main_view.dart';

import 'package:stacked/stacked_annotations.dart';

@StackedApp(
  routes: [
    StackedRoute(page: AuthView, initial: true),
    StackedRoute(page: LoginView),
    StackedRoute(page: MainView),
    
  ]
)
class AppSetup {}
