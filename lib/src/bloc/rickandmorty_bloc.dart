import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../services/GraphQLConfiguration.dart';
import '../services/QueryMutation.dart';
import './bloc.dart';

import "package:flutter/material.dart";

class RickAndMortyBloc extends Bloc<RickAndMortyEvent, RickAndMortyState> {

  RickAndMortyBloc() : super();

  GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();
  QueryMutation addMutation = QueryMutation();

  List<LazyCacheMap> characters = [];
  List<LazyCacheMap>  episodes = [];
  List<LazyCacheMap>  locations = [];

  String charactersFilter = '{}';
  String episodesFilter = '{}';
  String locationsFilter = '{}';

  @override
  RickAndMortyState get initialState => EpisodesState(result: null);

  @override
  Stream<RickAndMortyState> mapEventToState(RickAndMortyEvent event) async* {

    GraphQLClient _client = graphQLConfiguration.clientToQuery();

    if (event is FetchEpisodes) {
      debugPrint("------- mapEventToState event.filter= ${event.filter} ------");
      debugPrint(addMutation.getAllEpisodes(event.page, event.filter));
      QueryResult result = await _client.mutate(
        MutationOptions(
          document: addMutation.getAllEpisodes(event.page, event.filter),
        ),
      );
      if(episodesFilter != event.filter) {
        episodesFilter = event.filter;
        episodes.clear();
      }
      if(result != null && result.data != null && result.data['episodes']['results'] != null) {
        episodes.addAll(List<LazyCacheMap>.from(result.data['episodes']['results']));
        result.data['episodes']['results'] = episodes;
      }
      yield EpisodesState(result: result);

    }
    else if (event is FetchCharacters) {
      debugPrint("------- mapEventToState event.filter= ${event.filter} ------");
      debugPrint(addMutation.getAllCharacters(event.page, event.filter));
      QueryResult result = await _client.mutate(
        MutationOptions(
          document: addMutation.getAllCharacters(event.page, event.filter),
        ),
      );
      if(charactersFilter != event.filter) {
        charactersFilter = event.filter;
        characters.clear();
      }
      if(result != null && result.data != null && result.data['characters']['results'] != null) {
          characters.addAll(List<LazyCacheMap>.from(result.data['characters']['results']));
          result.data['characters']['results'] = characters;
      }
      yield CharactersState(result: result);

    } else if (event is FetchLocations) {
      debugPrint("------- mapEventToState event.filter= ${event.filter} ------");
      debugPrint(addMutation.getAllLocations(event.page, event.filter));
      QueryResult result = await _client.mutate(
        MutationOptions(
          document: addMutation.getAllLocations(event.page, event.filter),
        ),
      );
      if(locationsFilter != event.filter) {
        locationsFilter = event.filter;
        locations.clear();
      }
      if(result != null && result.data != null && result.data['locations']['results'] != null) {
        locations.addAll(List<LazyCacheMap>.from(result.data['locations']['results']));
        result.data['locations']['results'] = locations;
      }
      yield LocationsState(result: result);
    }
  }
}
