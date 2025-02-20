import 'dart:async';
import 'dart:math';
import 'package:alarm/alarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todo_list/data/data.dart';
import 'package:todo_list/data/repo/repository.dart';
import 'package:todo_list/main.dart';
import 'package:todo_list/screens/edit/cubit/edit_task_cubit.dart';
import 'package:todo_list/screens/edit/edit.dart';
import 'package:todo_list/screens/home/bloc/task_list_bloc.dart';
import 'package:todo_list/screens/setting/setting.dart';
import 'package:todo_list/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../alarm/AlarmNotification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

double menuvalue = 0;

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late List<AlarmSettings> alarms;
  static StreamSubscription<AlarmSettings>? subscription;
  late AnimationController _menuAnimationController;
  late Animation<double> _borderRadiusAnimation;

  @override
  void initState() {
    checkAndroidNotificationPermission();
    checkAndroidScheduleExactAlarmPermission();
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);
    super.initState();

    _menuAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _borderRadiusAnimation = Tween<double>(begin: 0.0, end: 24.0).animate(
      CurvedAnimation(
          parent: _menuAnimationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _menuAnimationController.dispose();
    super.dispose();
  }

  void loadAlarms() async {
    final fetchedAlarms = await Alarm.getAlarms();
    fetchedAlarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    setState(() {
      alarms = fetchedAlarms;
    });
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      alarmPrint('Requesting notification permission...');
      final res = await Permission.notification.request();
      alarmPrint(
        'Notification permission ${res.isGranted ? '' : 'not '}granted',
      );
    }
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) =>
            AlarmNotificationScreen(alarmSettings: alarmSettings),
      ),
    );
    loadAlarms();
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    if (kDebugMode) {
      print('Schedule exact alarm permission: $status.');
    }
    if (status.isDenied) {
      if (kDebugMode) {
        print('Requesting schedule exact alarm permission...');
      }
      final res = await Permission.scheduleExactAlarm.request();
      if (kDebugMode) {
        print(
            'Schedule exact alarm permission ${res.isGranted ? '' : 'not'} granted.');
      }
    }
  }

  final TextEditingController searchcontroller = TextEditingController();
  bool menuIsOpen = false;
  void _iconTapped() {
    setState(() {
      menuvalue == 0 ? menuvalue = 1 : menuvalue = 0;
    });
    if (menuIsOpen == false) {
      _menuAnimationController.forward();
      menuIsOpen = true;
    } else {
      _menuAnimationController.reverse();
      menuIsOpen = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              primaryContainer,
              primaryColor,
            ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 24,
                  ),
                  label: const Text(
                    "Settings",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white, iconColor: Colors.grey),
                  onPressed: () {
                    Navigator.of(context).push(effectRoute(SettingsPage()));
                    _iconTapped();
                  },
                )
              ],
            ),
          ),
          TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: menuvalue),
              duration: const Duration(milliseconds: 400),
              curve: Curves.ease,
              builder: (_, double val, __) {
                return (Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..setEntry(0, 3, 260 * val)
                    ..rotateY((pi / 6) * val),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(_borderRadiusAnimation.value),
                      topLeft: Radius.circular(_borderRadiusAnimation.value),
                    ),
                    child: GestureDetector(
                      onHorizontalDragEnd: (e) {
                        if (e.primaryVelocity! > 0) {
                          _iconTapped();
                        }else{
                          _iconTapped();
                        }
                      },
                      child: Scaffold(
                        appBar: AppBar(
                          systemOverlayStyle: const SystemUiOverlayStyle(
                              statusBarColor: Color(0xff794CFF),
                              statusBarBrightness: Brightness.light),
                          toolbarHeight: 0,
                          backgroundColor: const Color(0xff794CFF),
                        ),
                        // backgroundColor: Color.fromARGB(255, 208, 193, 234),
                        floatingActionButtonLocation:
                            FloatingActionButtonLocation.centerFloat,
                        floatingActionButton: FloatingActionButton.extended(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    BlocProvider<EditTaskCubit>(
                                      create: (context) => EditTaskCubit(
                                          TaskEntity(),
                                          context
                                              .read<Repository<TaskEntity>>()),
                                      child: const EditTaskScreen(),
                                    )));
                          },
                          label: const Row(
                            children: [
                              Text('Add New Task'),
                              SizedBox(width: 4),
                              Icon(CupertinoIcons.add),
                            ],
                          ),
                        ),
                        body: BlocProvider<TaskListBloc>(
                          create: (context) => TaskListBloc(
                              context.read<Repository<TaskEntity>>()),
                          child: SafeArea(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 90,
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 72,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(8),
                                                    bottomLeft:
                                                        Radius.circular(8)),
                                            gradient: LinearGradient(colors: [
                                              // more gradient
                                              // Color(0xFFFF9000),
                                              ThemeData.colorScheme.primary,
                                              ThemeData
                                                  .colorScheme.primaryContainer,
                                            ])),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  GestureDetector(
                                                    onTap: _iconTapped,
                                                    child: AnimatedIcon(
                                                      icon: AnimatedIcons
                                                          .menu_close,
                                                      progress:
                                                          _menuAnimationController,
                                                      size: 32,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text('To Do List',
                                                      style: ThemeData.textTheme
                                                          .headlineMedium),
                                                  InkWell(
                                                    onTap: () {
                                                      Share.share('https://github.com/Rmaawn');
                                                    },
                                                    child: Icon(
                                                      Icons.share,
                                                      color: ThemeData
                                                          .colorScheme
                                                          .onPrimary,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 8,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          height: 38,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              color: ThemeData
                                                  .colorScheme.onPrimary,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  spreadRadius: 1,
                                                  blurRadius: 20,
                                                )
                                              ]),
                                          child: Builder(builder: (context) {
                                            return TextField(
                                              onTapOutside: (event) {
                                                FocusScope.of(context)
                                                    .unfocus();
                                              },
                                              onChanged: (value) {
                                                context
                                                    .read<TaskListBloc>()
                                                    .add(TaskListSearch(value));
                                              },
                                              controller: searchcontroller,
                                              decoration: const InputDecoration(
                                                  prefixIcon: Icon(
                                                      CupertinoIcons.search,
                                                      color: primaryColor),
                                                  label:
                                                      Text('Search Tasks...')),
                                            );
                                          }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    child: Consumer<Repository<TaskEntity>>(
                                  builder: (context, model, child) {
                                    context
                                        .read<TaskListBloc>()
                                        .add(TaskListStarted());
                                    return BlocBuilder<TaskListBloc,
                                        TaskListState>(
                                      builder: (context, state) {
                                        if (state is TaskListSuccess) {
                                          return TaskList(
                                              items: state.items,
                                              themeData: ThemeData);
                                        } else if (state is TaskListEmpty) {
                                          return const EmptyState();
                                        } else if (state is TaskListLoading ||
                                            state is TaskListInitial) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else if (state is TaskListError) {
                                          return Center(
                                            child: Text(state.ErrorMessage),
                                          );
                                        } else {
                                          throw Exception(
                                              'state is not valid..');
                                        }
                                      },
                                    );
                                  },
                                )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ));
              })
        ],
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.items,
    required this.themeData,
  });

  final List<TaskEntity> items;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Today',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      width: 50,
                      height: 3,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                          color: themeData.colorScheme.primary,
                          borderRadius: BorderRadius.circular(1.5)),
                    )
                  ],
                ),
                MaterialButton(
                    color: const Color(0xFFEAEFf5),
                    textColor: secondaryTextColor,
                    // elevation: 0, to remove shadow
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (dialogcontext) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              icon: const Icon(
                                CupertinoIcons.exclamationmark_octagon,
                                size: 52,
                              ),
                              iconColor: Colors.red,
                              backgroundColor: Colors.grey.shade200,
                              title: const Center(
                                child: Text(
                                  'Are U Sure?',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              actions: [
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  color: Colors.grey.shade300,
                                  onPressed: () {
                                    context
                                        .read<TaskListBloc>()
                                        .add(TaskListDeleteAll());
                                    Navigator.of(dialogcontext).pop(true);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: const Text(
                                              'All tasks deleted successfully!'),
                                          backgroundColor: primaryColor,
                                          duration: const Duration(seconds: 1),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                color: primaryContainer,
                                                width: 1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          )),
                                    );
                                  },
                                  child: const Text('Yes'),
                                ),
                                const SizedBox(
                                  width: 24,
                                ),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  color: primaryColor,
                                  onPressed: () {
                                    Navigator.of(dialogcontext).pop(true);
                                  },
                                  child: const Text(
                                    'No',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              ],
                            );
                          });
                    },
                    child: const Row(
                      children: [
                        Text('Delete All'),
                        SizedBox(
                          width: 4,
                        ),
                        Icon(CupertinoIcons.delete_solid, size: 18),
                      ],
                    ))
              ],
            );
          } else {
            final TaskEntity task = items[index - 1];
            return Taskitem(task: task);
          }
        });
  }
}

class Taskitem extends StatefulWidget {
  static const double height = 78;
  static const double borderradius = 8;
  const Taskitem({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  State<Taskitem> createState() => _TaskitemState();
}

class _TaskitemState extends State<Taskitem> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    Color prioritycolor;
    switch (widget.task.priority) {
      case Priority.high:
        prioritycolor = highPriority;
        break;
      case Priority.normal:
        prioritycolor = normalPriority;
        break;
      case Priority.low:
        prioritycolor = lowPriority;
        break;
    }
    if (widget.task.isCompleted) {
      prioritycolor = Colors.grey;
    }
    return Dismissible(
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        widget.task.delete();
        context.read<TaskListBloc>().add(TaskListStarted());
        // final taskrepository =
        //     Provider.of<Repository<TaskEntity>>(context, listen: false);
        // taskrepository.delete(TaskEntity());
      },
      background: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'your task is deleted!',
            style: TextStyle(fontSize: 16),
          ),
          Lottie.asset('assets/trashlottie.json', width: 56),
        ],
      ),
      key: Key(widget.task.toString()),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlocProvider<EditTaskCubit>(
                  create: (context) => EditTaskCubit(
                      widget.task, context.read<Repository<TaskEntity>>()),
                  child: const EditTaskScreen())));
        },
        onLongPress: () {
          Clipboard.setData(ClipboardData(text: widget.task.name));
        },
        child: Container(
          margin: const EdgeInsets.only(top: 8),
          height: Taskitem.height,
          padding: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Taskitem.borderradius),
            color: widget.task.isCompleted
                ? Colors.grey.shade300
                : themeData.colorScheme.surface,
            // boxShadow: [
            //   BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.1))
            // ]
          ),
          child: Row(
            children: [
              MyCheckbox(
                value: widget.task.isCompleted,
                ontap: () {
                  setState(() {
                    widget.task.isCompleted = !widget.task.isCompleted;
                  });
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 24),
                  child: Text(
                    widget.task.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 24,
                        decoration: widget.task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: widget.task.isCompleted
                            ? Colors.grey.shade600
                            : null),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  widget.task.taskreminder
                      ? const Icon(
                          CupertinoIcons.bell,
                          size: 24,
                        )
                      : const Icon(CupertinoIcons.bell_slash, size: 22),
                  Text(
                    widget.task.tasktime.format(context).toString(),
                    style: TextStyle(
                        fontSize: 15,
                        decoration: widget.task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: widget.task.isCompleted
                            ? Colors.grey.shade600
                            : null),
                  ),
                  Text(
                    '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}',
                    style: TextStyle(
                        fontSize: 15,
                        decoration: widget.task.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: widget.task.isCompleted
                            ? Colors.grey.shade600
                            : null),
                  ),
                ],
              ),
              const SizedBox(
                width: 12,
              ),
              Container(
                width: 8,
                height: Taskitem.height,
                decoration: BoxDecoration(
                    color: prioritycolor,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(Taskitem.borderradius),
                        bottomRight: Radius.circular(Taskitem.borderradius))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
