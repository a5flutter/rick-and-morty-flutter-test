import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:equatable/equatable.dart';

abstract class RickAndMortyState extends Equatable {
  const RickAndMortyState();
}

class EpisodesState extends RickAndMortyState{

  const EpisodesState({this.result});
  final QueryResult result;

  @override
  List<Object> get props => [result];

}

class CharactersState extends RickAndMortyState{

  const CharactersState({this.result});
  final QueryResult result;

  @override
  List<Object> get props => [result];

}

class LocationsState extends RickAndMortyState{

  const LocationsState({this.result});
  final QueryResult result;

  @override
  List<Object> get props => [result];

}
