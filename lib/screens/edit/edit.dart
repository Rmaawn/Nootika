import 'package:alarm/alarm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';
import 'package:todo_list/screens/edit/cubit/edit_task_cubit.dart';
import 'package:todo_list/widgets.dart';
import 'package:todo_list/data/data.dart';
import 'package:todo_list/main.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({super.key});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

TimeOfDay selectedTime = TimeOfDay.now();
DateTime selectedDate = DateTime.now();

class _EditTaskScreenState extends State<EditTaskScreen> {
  // late final TextEditingController _controller =
  // TextEditingController(text: widget.task.name);

  late final TextEditingController titleTaskController;
  late final TextEditingController descriptionTaskController;

  @override
  void initState() {
    titleTaskController = TextEditingController(
        text: context.read<EditTaskCubit>().state.task.name);
    descriptionTaskController = TextEditingController(
        text: context.read<EditTaskCubit>().state.task.description);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      appBar: AppBar(
        // systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Color(0xff794CFF)),
        elevation: 0,
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Edit Task',
              style: themeData.textTheme.headlineMedium!
                  .apply(color: Colors.black),
            ),
            InkWell(
              onTap: () {
                if (context.read<EditTaskCubit>().state.task.name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: const Duration(seconds: 2),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),                      
                      ),
                      content: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('PLZ Write Something First!'),
                          Icon(
                            Icons.stop_screen_share_rounded,
                            color: Colors.white,
                          )
                        ],
                      )));
                }else{
                Share.share(context.read<EditTaskCubit>().state.task.name);
                }
              },
              child: const Icon(Icons.share, color: primaryTextColor),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final alarmDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          final alarmSettings = AlarmSettings(
            id: 42,
            dateTime: alarmDateTime,
            assetAudioPath: 'assets/blank.mp3',
            loopAudio: true,
            vibrate: true,
            volume: 0.8,
            fadeDuration: 3.0,
            notificationSettings: NotificationSettings(
              title: context.read<EditTaskCubit>().state.task.name,
              body: context.read<EditTaskCubit>().state.task.description,
              stopButton: "I Can Do it later",
              icon: 'notification_icon',
            ),
          );
          if (context.read<EditTaskCubit>().state.task.taskreminder) {
            await Alarm.set(alarmSettings: alarmSettings);
            // loadAlarms();
          }
          // loadAlarms();
          context.read<EditTaskCubit>().state.task.tasktime = selectedTime;
          context.read<EditTaskCubit>().state.task.taskdate = selectedDate;
          context.read<EditTaskCubit>().onSaveChangesClick();
          Navigator.of(context).pop();
        },
        label: const Row(
          children: [
            Text('Save Changes'),
            SizedBox(
              width: 6,
            ),
            Icon(
              CupertinoIcons.check_mark,
              // size: 24,
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              BlocBuilder<EditTaskCubit, EditTaskState>(
                builder: (context, state) {
                  final proirity = state.task.priority;
                  return Flex(
                    direction: Axis.horizontal,
                    children: [
                      Flexible(
                          flex: 1,
                          child: Prioritypicker(
                            callback: () {
                              context
                                  .read<EditTaskCubit>()
                                  .onPriorityChanged(Priority.high);
                            },
                            label: 'high',
                            color: highPriority,
                            isSelected: proirity == Priority.high,
                          )),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                          flex: 1,
                          child: Prioritypicker(
                            callback: () {
                              context
                                  .read<EditTaskCubit>()
                                  .onPriorityChanged(Priority.normal);
                            },
                            label: 'normal',
                            color: normalPriority,
                            isSelected: proirity == Priority.normal,
                          )),
                      const SizedBox(
                        width: 8,
                      ),
                      Flexible(
                          flex: 1,
                          child: Prioritypicker(
                            callback: () {
                              context
                                  .read<EditTaskCubit>()
                                  .onPriorityChanged(Priority.low);
                            },
                            label: 'low',
                            color: lowPriority,
                            isSelected: proirity == Priority.low,
                          )),
                    ],
                  );
                },
              ),
              TitleTextField(
                controller: titleTaskController,
              ),
              const SizedBox(
                height: 20,
              ),
              DesTextField(
                controller: descriptionTaskController,
              ),
              GestureDetector(
                onTap: () async {
                  {
                    await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then((value) {
                      if (value == null) {
                        return;
                      } else {
                        setState(() {
                          selectedTime = value;
                        });
                      }
                    });
                  }
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(20),
                  height: 55,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          selectedTime.format(context).toString(),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 95,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade300),
                        child: const Center(
                            child: Text(
                          'Pick Time',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  {
                    final DateTime? dateTime = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2025),
                    );
                    if (dateTime != null) {
                      setState(() {
                        selectedDate = dateTime;
                      });
                    }
                  }
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.all(20),
                  height: 55,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          selectedDate.toString().substring(0, 11),
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 12),
                        width: 95,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.shade300),
                        child: const Center(
                            child: Text(
                          'Pick Date',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 45,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Set Reminder',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    Switch(
                      value:
                          context.read<EditTaskCubit>().state.task.taskreminder,
                      onChanged: (value) {
                        setState(() {
                          !context.read<EditTaskCubit>().state.task.taskreminder
                              ? ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: primaryColor,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: primaryContainer, width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      content: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Reminder is Set Now Be Ready!'),
                                          Icon(
                                            Icons.alarm,
                                            color: Colors.white,
                                          )
                                        ],
                                      )))
                              : ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: Colors.grey.shade500,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.grey.shade700,
                                            width: 1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                              'Reminder is Off Now Be Cool!'),
                                          Icon(
                                            Icons.alarm_off,
                                            color: Colors.grey.shade800,
                                          )
                                        ],
                                      )));
                          context
                              .read<EditTaskCubit>()
                              .state
                              .task
                              .taskreminder = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
