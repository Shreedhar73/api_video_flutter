import 'package:api_video/commons/toast.dart';
import 'package:api_video/features/home_page/list_video_bloc/list_video_bloc.dart';
import 'package:api_video/features/pick_video/screens/pick_video_screen.dart';
import 'package:api_video/features/upload/blocs/upload_video_bloc/upload_video_bloc.dart';
import 'package:api_video/features/upload/data/upload_video_datasource/upload_video_datasource.dart';
import 'package:api_video/features/video_details/video_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<ListVideoBloc>().add(const ListVideoEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<UploadVideoBloc, UploadVideoState>(
        listener: (context, state) {
          if (state is UploadVideoSuccess) {
            Navigator.pop(context);
            ShowToast.show(context, 'Video Upload Success');
            context.read<ListVideoBloc>().add(const ListVideoEvent());
          } else if (state is UploadVideoLoading) {
            showModalBottomSheet(
              context: context,
              builder: (ctx) => Container(
                width: double.infinity,
                color: Colors.grey.withOpacity(0.2),
                height: 50,
                child: ValueListenableBuilder(
                    valueListenable: PercentageCalc.instance.percentage,
                    builder: (conts, val, _) => Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Text('$val % completed'))),
              ),
            );
          }
        },
        child: BlocConsumer<ListVideoBloc, ListVideoState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              backgroundColor: Colors.grey.withOpacity(0.2),
              // appBar: AppBar(),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // ListAllVideos().getAllVideos();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => const PickVideoScreen(),
                    ),
                  );
                },
                child: const Icon(Icons.add_a_photo_outlined),
              ),
              body: returnType(state),
            );
          },
        ),
      ),
    );
  }

  Widget returnType(ListVideoState state) {
    if (state is VideoListLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is VideoListLoaded) {
      return ListView.builder(
        itemCount: state.videoList.length,
        itemBuilder: (ctx, idx) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: ListTile(
            title: Text(state.videoList[idx].title ?? 'video title'),
            titleTextStyle: const TextStyle(color: Colors.white),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            shape: const RoundedRectangleBorder(
                side: BorderSide(color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(10))),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => VideoDetails(
                    videoData: state.videoList[idx],
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      return const Center(
        child: Text('Failed to load videos'),
      );
    }
  }
}
