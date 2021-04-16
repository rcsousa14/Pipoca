// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:stacked_services/stacked_services.dart' as _i8;

import '../constants/api_helpers/base_helper.dart' as _i3;
import '../constants/api_helpers/header.dart' as _i4;
import '../repositories/feed/feed_repository.dart' as _i13;
import '../repositories/user/auth_repository.dart' as _i5;
import '../repositories/user/user_repository.dart' as _i20;
import '../services/authentication_service.dart' as _i6;
import '../services/battery_service.dart' as _i7;
import '../services/caller.service.dart' as _i9;
import '../services/capture_png_service.dart' as _i10;
import '../services/connectivity_service.dart' as _i11;
import '../services/dynamicLink_service.dart' as _i12;
import '../services/feed_service.dart' as _i14;
import '../services/location_service.dart' as _i15;
import '../services/push_notification_service.dart' as _i17;
import '../services/shared_local_storage_service.dart' as _i18;
import '../services/social_share_service.dart' as _i19;
import '../services/third_party_service_model.dart' as _i23;
import '../services/user_service.dart' as _i21;
import '../services/validation_service.dart' as _i22;
import '../views/main_view/main_view_model.dart'
    as _i16; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(_i1.GetIt get,
    {String? environment, _i2.EnvironmentFilter? environmentFilter}) {
  final gh = _i2.GetItHelper(get, environment, environmentFilter);
  final thirdPartyServicesModule = _$ThirdPartyServicesModule();
  gh.lazySingleton<_i3.ApiBaseHelper>(() => _i3.ApiBaseHelper());
  gh.lazySingleton<_i4.ApiHeaders>(() => _i4.ApiHeaders());
  gh.lazySingleton<_i5.AuthenticationRepository>(
      () => _i5.AuthenticationRepository());
  gh.lazySingleton<_i6.AuthenticationService>(
      () => _i6.AuthenticationService());
  gh.lazySingleton<_i7.BatteryService>(() => _i7.BatteryService());
  gh.lazySingleton<_i8.BottomSheetService>(
      () => thirdPartyServicesModule.bottomSheetService);
  gh.lazySingleton<_i9.CallerService>(() => _i9.CallerService());
  gh.lazySingleton<_i10.CapturePngService>(() => _i10.CapturePngService());
  gh.lazySingleton<_i11.ConnectivityService>(() => _i11.ConnectivityService());
  gh.lazySingleton<_i8.DialogService>(
      () => thirdPartyServicesModule.dialogService);
  gh.lazySingleton<_i12.DynamicLinkService>(() => _i12.DynamicLinkService());
  gh.lazySingleton<_i13.FeedRepository>(() => _i13.FeedRepository());
  gh.lazySingleton<_i14.FeedService>(() => _i14.FeedService());
  gh.lazySingleton<_i15.LocationService>(() => _i15.LocationService());
  gh.lazySingleton<_i16.MainViewModel>(() => _i16.MainViewModel());
  gh.lazySingleton<_i8.NavigationService>(
      () => thirdPartyServicesModule.navigationService);
  gh.lazySingleton<_i17.PushNotificationService>(
      () => _i17.PushNotificationService());
  gh.lazySingleton<_i18.SharedLocalStorageService>(
      () => _i18.SharedLocalStorageService());
  gh.lazySingleton<_i8.SnackbarService>(
      () => thirdPartyServicesModule.snackbarService);
  gh.lazySingleton<_i5.SocialRepository>(() => _i5.SocialRepository());
  gh.lazySingleton<_i19.UrlLancherService>(() => _i19.UrlLancherService());
  gh.lazySingleton<_i20.UserRepository>(() => _i20.UserRepository());
  gh.lazySingleton<_i21.UserService>(() => _i21.UserService());
  gh.lazySingleton<_i22.ValidationService>(() => _i22.ValidationService());
  return get;
}

class _$ThirdPartyServicesModule extends _i23.ThirdPartyServicesModule {
  @override
  _i8.BottomSheetService get bottomSheetService => _i8.BottomSheetService();
  @override
  _i8.DialogService get dialogService => _i8.DialogService();
  @override
  _i8.NavigationService get navigationService => _i8.NavigationService();
  @override
  _i8.SnackbarService get snackbarService => _i8.SnackbarService();
}
