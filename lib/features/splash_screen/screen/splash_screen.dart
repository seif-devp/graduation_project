import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:graduation_project/features/splash_screen/cubit/splash_cubit.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/cupertino.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..initApp(),
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashComplete) {
            context.replace('/login');
          }
        },
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 3, 59, 122),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,            
            children: [
           Column(
              
               children: [
                 Lottie.asset(
                  'assets/icons/splash.json',
                  width: 200.w,
                  height: 200.h,
                               ),
               ],
             ),
             Text(
               'A Chance To Shine',
               textAlign: TextAlign.center,
               style: TextStyle(
                 fontSize: 26,
                 fontWeight: FontWeight.bold,
                 color: Color(0xFF00F2FE),
               ),
             )
          ],
            
          ),
        ),
      ),
    );
  }
}
