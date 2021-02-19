// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/authentication_service.dart';
import '../services/capture_png_service.dart';
import '../services/location_service.dart';
import '../views/main_view/main_view_model.dart';
import '../services/shared_local_storage_service.dart';
import '../services/third_party_service_model.dart';
import '../services/social_share_service.dart';
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
  gh.lazySingleton<AuthenticationService>(() => AuthenticationService());
  gh.lazySingleton<BottomSheetService>(
      () => thirdPartyServicesModule.bottomSheetService);
  gh.lazySingleton<CapturePngService>(() => CapturePngService());
  gh.lazySingleton<DialogService>(() => thirdPartyServicesModule.dialogService);
  gh.lazySingleton<LocationService>(() => LocationService());
  gh.lazySingleton<MainViewModel>(() => MainViewModel());
  gh.lazySingleton<NavigationService>(
      () => thirdPartyServicesModule.navigationService);
  gh.lazySingleton<SnackbarService>(
      () => thirdPartyServicesModule.snackbarService);
  gh.lazySingleton<UrlLancherService>(() => UrlLancherService());
  gh.lazySingleton<ValidationService>(() => ValidationService());
  gh.lazySingleton<YoutubeService>(() => YoutubeService());

  // Eager singletons must be registered in the right order
  gh.singleton<SharedLocalStorageService>(SharedLocalStorageService());
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
