import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/models/link_info_model.dart';
import 'package:pipoca/src/repositories/feed/link_repository.dart';
import 'package:stacked/stacked.dart';

class LinkViewModel extends FutureViewModel<LinkInfo> {
  final String url;
  LinkViewModel(this.url);

  final _linkRepo = locator<LinkRepository>();
  @override
  Future<LinkInfo> futureToRun() => _linkRepo.getLink(url);
}
