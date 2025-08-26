import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/main.dart';
import 'package:todo_list/screens/home/home.dart';
import 'package:todo_list/widgets.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}
  bool isVibre = true;
  double soundLevel = 6.0;
class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 213, 216, 248),
            appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,size: 26,),
          onPressed: () {
            saveSettings(soundLevel, isVibre);
            Navigator.of(context).push(effectRoute(const HomeScreen()));
          },
        ),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.settings, color: Colors.white,size: 32),
            SizedBox(width: 5),
            Text(
          'Settings',
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24),
        ),
          ],
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        height: 600,
        child: Stack(
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
            ),
            Positioned(
              top: 75,
              left: 16,
              right: 16,
              child: Container(
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child:  Column(
                  spacing: 25,
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ExpansionTile(
                    // collapsedBackgroundColor: const Color(0xff00CCDD),
                    backgroundColor: const Color.fromARGB(255, 232, 234, 255),
                    expandedCrossAxisAlignment: CrossAxisAlignment.start,
                    title: const Text('Sound',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                    children: [
                      Slider(
                        min: 0,
                        max: 10,
                        divisions: 10,
                        value: soundLevel,
                        label:soundLevel.toString(),
                        onChanged: (double value) {
                          setState(() {
                            soundLevel = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ExpansionTile(
                    // collapsedBackgroundColor: const Color(0xff00CCDD),
                    backgroundColor: const Color.fromARGB(255, 232, 234, 255),
                    expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                    title: const Text('Vibration',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600)),
                    children: [
                      SwitchListTile(
                        title: isVibre ? const Text('On') : const Text('Off'),
                        value: isVibre,
                        onChanged: (bool value) {
                          setState(() {
                            isVibre = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ExpansionTile(
                    // collapsedBackgroundColor: const Color(0xff00CCDD),
                    backgroundColor: const Color.fromARGB(255, 232, 234, 255),
                    expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                    title: const Text('Contact Us',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
                    children: [
                      ListTile(
                        title: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Telegram'),
                                InkWell(
                                    onTap: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              duration:
                                                  const Duration(seconds: 3),
                                              backgroundColor:
                                                  const Color(0xff399918),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color:
                                                        Colors.green.shade900,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              content: const Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('Copied'),
                                                  SizedBox(width: 4),
                                                  Icon(
                                                    Icons.check_circle_sharp,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              )));
                                      Clipboard.setData(const ClipboardData(
                                          text: '@R_maawn'));
                                    },
                                    child: const Icon(
                                      Icons.content_copy,
                                      size: 22,
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Email'),
                                InkWell(
                                    onTap: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              duration:
                                                  const Duration(seconds: 2),
                                              backgroundColor:
                                                  const Color(0xff399918),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color:
                                                        Colors.green.shade900,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              content: const Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('Copied'),
                                                  SizedBox(width: 4),
                                                  Icon(
                                                    Icons.check_circle_sharp,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              )));
                                      Clipboard.setData(
                                          const ClipboardData(text:'armanmohebali@outlook.com'));
                                    },
                                    child: const Icon(
                                      Icons.content_copy,
                                      size: 22,
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Github'),
                                InkWell(
                                    onTap: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              duration:
                                                  const Duration(seconds: 2),
                                              backgroundColor:
                                                  const Color(0xff399918),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color:
                                                        Colors.green.shade900,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              content: const Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text('Copied'),
                                                  SizedBox(width: 4),
                                                  Icon(
                                                    Icons.check_circle_sharp,
                                                    color: Colors.white,
                                                  )
                                                ],
                                              )));
                                      Clipboard.setData(const ClipboardData(
                                          text: 'https://github.com/Rmaawn'));
                                    },
                                    child: const Icon(
                                      Icons.content_copy,
                                      size: 22,
                                    )),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            const Text('Made With ❤️ By Rmaan'),
                            const Text('v0.10')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void saveSettings(double soundLevel, bool isVibre) {
  final box = Hive.box('settings');
  box.put('soundLevel', soundLevel);
  box.put('isVibre', isVibre);
}

