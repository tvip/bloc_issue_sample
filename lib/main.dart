import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc/bloc.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}

///#######
class UpdateDataEvent {}

@immutable
class DataState extends Equatable {
  final List<String> values;

  DataState(this.values): super([values]);

  @override
  String toString() => '$runtimeType values: $values';
}

class DataBloc extends Bloc<UpdateDataEvent, DataState> {
  @override
  DataState get initialState => DataState(['a', 'b', 'c']);

  @override
  Stream<DataState> mapEventToState(
      UpdateDataEvent event,
      ) async* {
      yield currentState..values.add('D');
  }
}

///#######

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _dataBloc = DataBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _dataBloc.dispatch(UpdateDataEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: BlocBuilder(
              bloc: _dataBloc,
              builder: (BuildContext context, DataState state) {
                print('Widget: state.values: ${state.values}');
                return Text(
                  '${state.values}',
                  style: Theme.of(context).textTheme.display1,
                );
              })),
    );
  }
}

class SimpleBlocDelegate extends BlocDelegate {

  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}
