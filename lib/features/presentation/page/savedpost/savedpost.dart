import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumeo/features/presentation/cubit/savedposts/savedpost_cubit.dart';
import 'package:lumeo/features/presentation/page/savedpost/savedpost_main_widget.dart';
import 'package:lumeo/injection_container.dart' as di;


class SavedPostpage extends StatelessWidget {
  const SavedPostpage({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
        providers: [
          BlocProvider<SavedpostCubit>(
            create: (context) => di.sl<SavedpostCubit>(),
          ),
        ],
        child:  const SavedpostMainWidget(
      
        ));
  }
}