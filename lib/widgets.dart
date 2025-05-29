import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/main.dart';
import 'package:todo_list/screens/edit/cubit/edit_task_cubit.dart';

class TitleTextField extends StatelessWidget {
  const TitleTextField({
    super.key,
    required this.controller,
  });
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        title: TextField(
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          onChanged: (value) {
            context.read<EditTaskCubit>().onTitleTextChanged(value);
          },
          controller: controller,
          maxLines: 1,
          // cursorHeight: isForDescription ? 60 : null,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
              border: null,
              counter: Container(),
              labelText: 'Title',
              prefixIcon: null,
            floatingLabelBehavior: FloatingLabelBehavior.always,
              

                             filled: true,
                fillColor: Colors.transparent,
              enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white),
            ),
                  ),
          // onFieldSubmitted: (value) {},
        ),
      ),
    );
  }
}

class DesTextField extends StatelessWidget {
  const DesTextField({
    super.key,
    required this.controller,
  });
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        title: TextField(
          onTapOutside: (event) => FocusScope.of(context).unfocus(),
          onChanged: (value) {
            context.read<EditTaskCubit>().onDescriptionTextChanged(value);
          },
          controller: controller,
          maxLines: null,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: null,
            counter: Container(),
            labelText: 'Add Note...',
            // icon: const Icon(
            //   CupertinoIcons.bookmark,
            //   color: Colors.grey,
            // ),
            filled: true,
            fillColor: Colors.transparent,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white),
            ),
          ),

          // onFieldSubmitted: (value) {},
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset('assets/Empty_State2.json', width: 265),
        const SizedBox(
          height: 24,
        ),
        const Text(
          'Your Task List is Empty',
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}

class MyCheckbox extends StatelessWidget {
  final bool value;
  final Function() ontap;
  const MyCheckbox({super.key, required this.value, required this.ontap});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: ontap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border:
                !value ? Border.all(width: 2, color: secondaryTextColor) : null,
            color: value ? Colors.grey : null),
        child: value
            ? Icon(
                CupertinoIcons.check_mark,
                color: themeData.colorScheme.onPrimary,
                size: 16,
              )
            : null,
      ),
    );
  }
}

class PriorityCheck extends StatelessWidget {
  final bool value;
  final Color color;

  const PriorityCheck({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      width: 20,
      height: 20,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              color: themeData.colorScheme.onPrimary,
              size: 16,
            )
          : null,
    );
  }
}

class Prioritypicker extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback callback;
  const Prioritypicker(
      {super.key,
      required this.label,
      required this.color,
      required this.isSelected,
      required this.callback});

  @override
  Widget build(BuildContext context) {
    // final ThemeData themeData = Theme.of(context);

    return InkWell(
      onTap: callback,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border:
              Border.all(width: 2, color: secondaryTextColor.withOpacity(0.2)),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(label),
            ),
            Positioned(
              right: 6,
              top: 0,
              bottom: 0,
              child: Center(
                child: PriorityCheck(
                  value: isSelected,
                  color: color,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

PageRouteBuilder effectRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
