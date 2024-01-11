import 'package:api_video/features/home_page/home.dart';
import 'package:api_video/features/home_page/list_video_bloc/list_video_bloc.dart';
import 'package:api_video/features/pick_video/blocs/pick_video_bloc/pick_video_bloc.dart';
import 'package:api_video/features/upload/blocs/upload_video_bloc/upload_video_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ListVideoBloc()),
        BlocProvider(create: (context) => PickVideoBloc()),
        BlocProvider(create: (context) => UploadVideoBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
              primary: Colors.black.withOpacity(0.5)),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
