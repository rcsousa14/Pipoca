// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

import '../constants/api/header.dart';
import '../services/authentication_service.dart';
import '../services/battery_service.dart';
import '../services/caller.service.dart';
import '../services/capture_png_service.dart';
import '../services/connectivity_service.dart';
import '../services/dynamicLink_service.dart';
import '../repositories/feed/feed_repository.dart';
import '../services/feed_service.dart';
import '../repositories/feed/link_repository.dart';
import '../services/location_service.dart';
import '../views/main_view/main_view_model.dart';
import '../repositories/feed/post_point_repository.dart';
import '../services/push_notification_service.dart';
import '../services/shared_local_storage_service.dart';
import '../services/third_party_service_model.dart';
import '../services/social_share_service.dart';
import '../repositories/user/user_repository.dart';
import '../services/user_service.dart';
import '../services/validation_service.dart';
import '../services/youtube_service.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  gh.lazySingleton<ApiHeaders>(() => ApiHeaders());
  gh.lazySingleton<AuthenticationService>(() => AuthenticationService());
  gh.lazySingleton<BatteryService>(() => BatteryService());
  gh.lazySingleton<BottomSheetService>(
      () => thirdPartyServicesModule.bottomSheetService);
  gh.lazySingleton<CallerService>(() => CallerService());
  gh.lazySingleton<CapturePngService>(() => CapturePngService());
  gh.lazySingleton<ConnectivityService>(() => ConnectivityService());
  gh.lazySingleton<DialogService>(() => thirdPartyServicesModule.dialogService);
  gh.lazySingleton<DynamicLinkService>(() => DynamicLinkService());
  gh.lazySingleton<FeedRepository>(() => FeedRepository());
  gh.lazySingleton<FeedService>(() => FeedService());
  gh.lazySingleton<LinkRepository>(() => LinkRepository());
  gh.lazySingleton<LocationService>(() => LocationService());
  gh.lazySingleton<MainViewModel>(() => MainViewModel());
  gh.lazySingleton<NavigationService>(
      () => thirdPartyServicesModule.navigationService);
  gh.lazySingleton<PostPointRepository>(() => PostPointRepository());
  gh.lazySingleton<PushNotificationService>(() => PushNotificationService());
  gh.lazySingleton<SharedLocalStorageService>(
      () => SharedLocalStorageService());
  gh.lazySingleton<SnackbarService>(
      () => thirdPartyServicesModule.snackbarService);
  gh.lazySingleton<UrlLancherService>(() => UrlLancherService());
  gh.lazySingleton<UserRepository>(() => UserRepository());
  gh.lazySingleton<UserService>(() => UserService());
  gh.lazySingleton<ValidationService>(() => ValidationService());
  gh.lazySingleton<YoutubeService>(() => YoutubeService());
  return get;
}

class _$ThirdPartyServicesModule extends ThirdPartyServicesModule {
  @override
  BottomSheetService get bottomSheetService => BottomSheetService();
  @override
  DialogService get dialogService => DialogService();
  @override
  NavigationService get navigationService => NavigationService();
  @override
  SnackbarService get snackbarService => SnackbarService();
}
