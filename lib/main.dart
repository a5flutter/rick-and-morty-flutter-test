import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/cupertino.dart';
import 'src/bloc/bloc.dart';
import 'src/bloc/rickandmorty_bloc.dart';
import 'src/bloc/rickandmorty_state.dart';
import 'src/services/GraphQLConfiguration.dart';

GraphQLConfiguration graphQLConfiguration = GraphQLConfiguration();

void main() => runApp(
      GraphQLProvider(
        client: graphQLConfiguration.client,
        child: CacheProvider(child: MyApp()),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => RickAndMortyBloc()),
        ],
        child: MaterialApp(
          title: 'Rick\'n\'Morty GraphQL',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: MyHomePage(title: 'Rick\'n\'Morty GraphQL'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> tabIndexes = [
    1,
    1,
    1,
  ];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _charactersFilterController.addListener(() {
      debugPrint(_charactersFilterController.text);

      SchedulerBinding.instance.addPostFrameCallback((_) {
        // start loading data
        setState(() {
          charactersFilter = _charactersFilterController.text;
          onTapped(1);
        });
      });

    });

    _episodesFilterController.addListener(() {
      debugPrint(_episodesFilterController.text);
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          episodesFilter = _episodesFilterController.text;
          onTapped(0);
        });
      });
    });

    _locationsFilterController.addListener(() {
      debugPrint(_locationsFilterController.text);
      SchedulerBinding.instance.addPostFrameCallback((_) {
        setState(() {
          locationsFilter = _locationsFilterController.text;
          onTapped(2);
        });
      });
    });

    BlocProvider.of<RickAndMortyBloc>(context).add(FetchEpisodes(page: 1, filter: '{}'));
  }

  TextEditingController _charactersFilterController = new TextEditingController();
  String charactersFilter = '';
  TextEditingController _episodesFilterController = new TextEditingController();
  String episodesFilter = '';
  TextEditingController _locationsFilterController = new TextEditingController();
  String locationsFilter = '';

  int currentTabIndex = 0;

  onTapped(int index) {
    setState(() {
      currentTabIndex = index;
    });
    if (index == 0) {
      BlocProvider.of<RickAndMortyBloc>(context)
          .add(FetchEpisodes(page: tabIndexes[index], filter: '{name: \"${episodesFilter}\"}'));
    } else if (index == 1) {
      BlocProvider.of<RickAndMortyBloc>(context)
          .add(FetchCharacters(page: tabIndexes[index], filter: '{name: \"${charactersFilter}\"}'));
    } else if (index == 2) {
      BlocProvider.of<RickAndMortyBloc>(context)
          .add(FetchLocations(page: tabIndexes[index], filter: '{name: \"${locationsFilter}\"}'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      // Body Where the content will be shown of each page index
      body: BlocBuilder<RickAndMortyBloc, RickAndMortyState>(
          builder: (BuildContext context, RickAndMortyState state) {

//         _charactersFilterController.text = charactersFilter;
//         _locationsFilterController.text = locationsFilter;
//         _episodesFilterController.text = episodesFilter;

        if (state is CharactersState) {
          if (state.result != null) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              setState(() {
                isLoading = state.result.loading;
              });
            });
          }
          if (state.result == null ||
              state.result.data == null ||
              state.result.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(children: <Widget>[
            TextField(
              controller: _charactersFilterController,
              scrollPadding: EdgeInsets.all(5),
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 20.0,
                ),
                border: InputBorder.none,
                hintText: 'Search characters by name',
              ),
            ),
            Expanded(
                child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!isLoading &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          // start loading data
                          setState(() {
                            isLoading = true;
                            tabIndexes[1]++;
                            onTapped(1);
                          });
                        });
                      }
                    },
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.all(5),
                          onTap: () => {},
                          title: Text(state.result.data['characters']['results']
                              [index]['name']),
                          leading: Image.network(state.result.data['characters']
                              ['results'][index]['image']),
                          subtitle: Text(state.result.data['characters']
                              ['results'][index]['species']),
                        );
                      },
                      itemCount:
                          state.result.data['characters']['results'].length,
                    )))
          ]);
        } else if (state is EpisodesState) {
          if (state.result != null) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              setState(() {
                isLoading = state.result.loading;
              });
            });
          }
          if (state.result == null ||
              state.result.data == null ||
              state.result.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(children: <Widget>[
            TextField(
              controller: _episodesFilterController,
              scrollPadding: EdgeInsets.all(5),
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 20.0,
                ),
                border: InputBorder.none,
                hintText: 'Search episodes by name',
              ),
            ),
            Expanded(
                child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!isLoading &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          // start loading data
                          setState(() {
                            isLoading = true;
                            tabIndexes[0]++;
                            onTapped(0);
                          });
                        });
                      }
                    },
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.all(5),
                          onTap: () => {},
                          title: Text(state.result.data['episodes']['results']
                              [index]['name']),
                          subtitle: Text(state.result.data['episodes']
                              ['results'][index]['episode']),
                        );
                      },
                      itemCount:
                          state.result.data['episodes']['results'].length,
                    )))
          ]);
        } else if (state is LocationsState) {
          if (state.result != null) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              setState(() {
                isLoading = state.result.loading;
              });
            });
          }
          if (state.result == null ||
              state.result.data == null ||
              state.result.loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(children: <Widget>[
            TextField(
              controller: _locationsFilterController,
              scrollPadding: EdgeInsets.all(5),
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 20.0,
                ),
                border: InputBorder.none,
                hintText: 'Search location by name',
              ),
            ),
            Expanded(
                child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollInfo) {
                      if (!isLoading &&
                          scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                        SchedulerBinding.instance.addPostFrameCallback((_) {
                          // start loading data
                          setState(() {
                            isLoading = true;
                            tabIndexes[2]++;
                            onTapped(2);
                          });
                        });
                      }
                    },
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.all(5),
                          onTap: () => {},
                          title: Text(state.result.data['locations']['results']
                              [index]['name']),
                          leading: Text(state.result.data['locations']
                              ['results'][index]['type']),
                          subtitle: Text(state.result.data['locations']
                              ['results'][index]['dimension']),
                        );
                      },
                      itemCount:
                          state.result.data['locations']['results'].length,
                    )))
          ]);
        }
      }),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentTabIndex,
          onTap: (int index) {
            onTapped(index);
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.list), title: Text("Episodes")),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text("Characters")),
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text("Locations"))
          ]),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
