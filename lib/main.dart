import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/data/repo/repository.dart';
import 'package:todo_list/data/source/hive_task_source.dart';
import 'package:todo_list/screens/home/home.dart';
import 'data/data.dart';

const taskboxname = 'tasks';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskEntityAdapter());
  Hive.registerAdapter(PriorityAdapter());
  Hive.registerAdapter(TimeOfDayAdapter());
  await Hive.openBox<TaskEntity>(taskboxname);
  await Hive.openBox('settings');

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: primaryColor));
  runApp(ChangeNotifierProvider<Repository<TaskEntity>>(
      create: (context) =>
          Repository<TaskEntity>(HiveTaskDataSource(Hive.box(taskboxname))),
      child: const MyApp()));
}

const Color primaryColor = Color(0xff794CFF);
const Color primaryContainer = Color(0xff5C0AFF);
const secondaryTextColor = Color(0xffAFBED0); 
const highPriority = primaryColor;
const normalPriority = Color(0xffF09819);
const lowPriority = Color(0xff3BE1F1);
const primaryTextColor = Color(0xff1D2830);



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(const TextTheme(
            headlineMedium: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.white))),

        inputDecorationTheme: const InputDecorationTheme(
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: InputBorder.none,
            prefixIconColor: secondaryTextColor,
            labelStyle: TextStyle(color: secondaryTextColor)),
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          primaryContainer: primaryContainer,
          onPrimary: Colors.white,
          surface: Color(0xffF3F5F8),
          onSurface: primaryTextColor,
          secondary: primaryColor,
          onSecondary: Colors.white,
        ),
        useMaterial3: true,
        // textTheme: TextTheme(headlineMedium: TextStyle(fontSize: 84)),
      ),
      home: const HomeScreen(),
    );
  }
}
