import 'dart:developer';

import 'package:api_video/commons/toast.dart';
import 'package:api_video/commons/widgets/text_field_widget.dart';
import 'package:api_video/features/pick_video/blocs/pick_video_bloc/pick_video_bloc.dart';
import 'package:api_video/features/pick_video/screens/widgets/video_pickedwidget.dart';
import 'package:api_video/features/upload/blocs/upload_video_bloc/upload_video_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PickVideoScreen extends StatefulWidget {
  const PickVideoScreen({super.key});

  @override
  State<PickVideoScreen> createState() => _PickVideoScreenState();
}

class _PickVideoScreenState extends State<PickVideoScreen> {
  final TextEditingController label = TextEditingController();
  final TextEditingController description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: BlocProvider(
        create: (context) => PickVideoBloc(),
        child: Builder(builder: (context) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Pick Videos'),
                actions: [
                  BlocBuilder<PickVideoBloc, PickVideoState>(
                    builder: (context, state) {
                      return MaterialButton(
                        onPressed: () {
                          if (state is VideoPickedState) {
                            context
                                .read<UploadVideoBloc>()
                                .add(UploadLocalVideoEvent(
                                  fileParams: UploadLocalVideoParams(
                                    file: state.pickedVideos.first,
                                    title: label.text,
                                    description: description.text,
                                  ),
                                ));
                          } else {
                            ShowToast.show(
                              context,
                              "please pick a Video first",
                            );
                          }
                        },
                        child: const Text('Upload'),
                      );
                    },
                  )
                ],
              ),
              body: BlocConsumer<PickVideoBloc, PickVideoState>(
                listener: (context, state) {
                  if (state is VideoPickedState) {
                    log('Video is Picked${state.pickedVideos}');
                  } else if (state is PickVideoError) {
                    log('Failed to pick video');
                  }
                },
                builder: (context, state) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VideoPickedWidget(),
                      TextFieldWidget(
                        controller: label,
                        label: 'Title',
                      ),
                      TextFieldWidget(
                        controller: description,
                        label: 'Description',
                      ),
                      if (state is VideoPickedState) const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
