
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:injectable/injectable.dart';



@lazySingleton
class DynamicLinkService {

  
 
  Future handleDynamicLink() async {
    
    // final PendingDynamicLinkData data =
    //     await FirebaseDynamicLinks.instance.getInitialLink();
   
    //_handleDeepLinkStartup(data);

    // INTO FOREGROUND FROM DYNAMIC LINK LOGIC
    // FirebaseDynamicLinks.instance.onLink(
    //     onSuccess: (PendingDynamicLinkData dynamicLinkData?) async {
      
    // //  _handleDeepLink(dynamicLinkData);
    // }, onError: (OnLinkErrorException e) async {
      
    // });
  }

  Future<String> shareView(
      int id, String title, String description, String image) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://wambo.page.link',
      link: Uri.parse('https://wambo.page.link/product?id=$id'),
      androidParameters: AndroidParameters(
        packageName: 'co.ao.wambo',
        minimumVersion: 0,
        fallbackUrl: Uri.parse('http://wamboapi.herokuapp.com'),
      ),
      iosParameters: IosParameters(
          bundleId: 'co.ao.wambo',
          fallbackUrl: Uri.parse('http://wamboapi.herokuapp.com'),
          minimumVersion: '1.0.0'),
      googleAnalyticsParameters: GoogleAnalyticsParameters(
        campaign: 'example-promo',
        medium: 'social',
        source: 'orkut',
      ),
      itunesConnectAnalyticsParameters: ItunesConnectAnalyticsParameters(
        providerToken: '123456',
        campaignToken: 'example-promo',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          title: title, description: description, imageUrl: Uri.parse(image)),
    );

    final Uri link = await parameters.buildUrl();

    final ShortDynamicLink shortenedLink =
        await DynamicLinkParameters.shortenUrl(
      link,
      DynamicLinkParametersOptions(
          shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
    );
    return shortenedLink.shortUrl.toString();
  }

  // void _handleDeepLink(PendingDynamicLinkData data) {
  //   final Uri deepLink = data?.link;

  //   if (deepLink != null) {
  //     var isProduct = deepLink.pathSegments.contains('product');
  //     var isCompany = deepLink.pathSegments.contains('company');
  //     if (isProduct) {
  //       var id = int.parse(deepLink.queryParameters['id']);
  //       if (id != null) {
         
  //         _navigationService.navigateTo(productRoute,
  //             arguments: ProductViewArguments(
  //                 id: id, navigation: 'home', choice: ListChoice.home),
  //             id: ListChoice.home.nestedKeyValue());
  //         _drawer.setIndex(ListChoice.home.nestedKeyValue());
  //       } else {
  //         _navigationService.replaceWith(Routes.drawerView,
  //             arguments: DrawerViewArguments(
  //               currentNavigation: ListChoice.home.nestedKeyValue(),
  //             ));
  //       }
  //     }
  //     if (isCompany) {
  //       var keyword = deepLink.queryParameters['keyword'];
  //       if (keyword != null) {
  //         _navigationService.navigateTo(productsRoute,
  //             arguments: ProductsViewArguments(
  //                 keyword: keyword,
  //                 navigation: 'home',
  //                 choice: ListChoice.home),
  //             id: ListChoice.home.nestedKeyValue());
  //       } else {
  //         _navigationService.replaceWith(Routes.drawerView,
  //             arguments: DrawerViewArguments(
  //               currentNavigation: ListChoice.home.nestedKeyValue(),
  //             ));
  //       }
  //     }
  //   }
  // }

//   void _handleDeepLinkStartup(PendingDynamicLinkData data) {
//     final Uri deepLink = data?.link;

//     if (deepLink != null) {
//       var isProduct = deepLink.pathSegments.contains('product');
//       var isCompany = deepLink.pathSegments.contains('company');
//       if (isProduct) {
//         var id = int.parse(deepLink.queryParameters['id']);
//         if (id != null) {
         

//           _navigationService.replaceWith(Routes.productView,
//               arguments: ProductViewArguments(
//                   id: id, navigation: 'link', choice: ListChoice.home),
//               );
//            _navigationService.replaceWith(productRoute,
//               arguments: ProductViewArguments(
//                   id: id, navigation: 'link', choice: ListChoice.home),
//                   id: ListChoice.home.nestedKeyValue()
//               );

//         } else {
//           _navigationService.replaceWith(Routes.drawerView,
//               arguments: DrawerViewArguments(
//                 currentNavigation: ListChoice.home.nestedKeyValue(),
//               ));
//         }
//       }
//       if (isCompany) {
//         var keyword = deepLink.queryParameters['keyword'];
//         if (keyword != null) {
//              _navigationService.replaceWith(Routes.productsView,
//               arguments: ProductsViewArguments(
//                   keyword: keyword, navigation: 'link', choice: ListChoice.home),
//               );
//            _navigationService.replaceWith(productsRoute,
//               arguments: ProductsViewArguments(
//                   keyword: keyword, navigation: 'link', choice: ListChoice.home),
//                   id: ListChoice.home.nestedKeyValue()
//               );

         
//         } else {
//           _navigationService.replaceWith(Routes.drawerView,
//               arguments: DrawerViewArguments(
//                 currentNavigation: ListChoice.home.nestedKeyValue(),
//               ));
//         }
//       }
//     }
//   }
 }
