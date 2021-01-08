import 'package:equatable/equatable.dart';

abstract class RickAndMortyEvent extends Equatable {
  const RickAndMortyEvent();
}

class FetchEpisodes extends RickAndMortyEvent {
  FetchEpisodes({this.page, this.filter});
  final int page;
  final String filter;

  @override
  List<Object> get props => [page, filter];
}

class FetchCharacters extends RickAndMortyEvent {
  FetchCharacters({this.page, this.filter});
  final int page;
  final String filter;

  @override
  List<Object> get props => [page, filter];
}

class FetchLocations extends RickAndMortyEvent {
  FetchLocations({this.page, this.filter});

  final int page;
  final String filter;

  @override
  List<Object> get props => [page, filter];
}
