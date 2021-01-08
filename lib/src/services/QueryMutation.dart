class QueryMutation {

    String getAllEpisodes(int page, String filter) {

      return '''
                  query {
    episodes(page:${page}, filter: ${filter}) {
      results {
        name
        episode
      }
    }
  }''';
    }

      String getAllCharacters(int page, String filter) {
        return '''
                  query {
    characters(page:${page}, filter: ${filter}) {
      results {
        name
        species
        gender
        image
        type
      }
    }
  }''';
      }

      String getAllLocations(int page, String filter) {
        return '''
                  query {
    locations(page:${page}, filter: ${filter}) {
      results {
        name
        type
        dimension
      }
    }
  }''';
      }
}