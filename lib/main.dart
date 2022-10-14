import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/layout/news_app/Cubit/cubit.dart';
import 'package:flutter_projects/layout/news_app/Cubit/states.dart';
import 'package:flutter_projects/layout/shop_app/bloc/cubit.dart';
import 'package:flutter_projects/layout/shop_app/shop_layout.dart';
import 'package:flutter_projects/modules/bmi_app/bmi/bmi_calculator.dart';
import 'package:flutter_projects/shared/bloc_observer.dart';
import 'package:flutter_projects/shared/network/local/cache_helper.dart';
import 'package:flutter_projects/shared/network/remote/dio_helper.dart';
import 'package:flutter_projects/shared/network/shared.styles/themes.dart';
import 'package:flutter_projects/shared/shared.components/constants.dart';
import 'layout/news_app/news_layout.dart';
import 'layout/todo_app/todo_layout.dart';
import 'modules/basices_apps/TasksUI/tasks_ui.dart';
import 'modules/basices_apps/shop_food_ui/food_ui.dart';
import 'modules/counter/counter_screen.dart';
import 'modules/shop_app/login/shop_login_screen.dart';
import 'modules/shop_app/on_boarding/on_boarding.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  Dio_Helper.init();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getBoolean(key: 'isDark');
  dynamic onBoarding = false;
  onBoarding = CacheHelper.getData(key: "OnBoarding");
  token = CacheHelper.getData(key: "token");
  print(token);
  // علشان اقدر اني افتح ع الهوم علي طول لو انا سجلت
  late Widget widget;
  if (onBoarding != null) {
    if (token == null) {
      widget = ShopLoginScreen();
    } else {
      widget = ShopLayout();
    }
  } else {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(
    isDark,
    widget,
  ));
}

// Stateless
// StateFul
class MyApp extends StatelessWidget {
  final bool? isDark;
  final Widget start;
  const MyApp(
    this.isDark,
    this.start,
  );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) => NewsCubit()
              ..getBusinessData()
              ..getSportsData()
              ..getScienceData()
              ..changeAppMode(fromShared: isDark)),
        BlocProvider(
          create: (BuildContext context) => ShopCubit()
            ..getHomeData()
            ..getCategoriesData()
            ..getFavData()
            ..getProfileData(),
        ),
      ],
      child: BlocConsumer<NewsCubit, NewsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            darkTheme: darkTheme,
            theme: lightTheme,
            themeMode: NewsCubit.get(context).isDark
                ? ThemeMode.dark
                : ThemeMode.light,
            home: TasksUIScreen(),
          );
        },
      ),
    );
  }
}
