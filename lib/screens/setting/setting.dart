import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    
  bool isVibre = true;
  double volume = 0.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
        backgroundColor: const Color(0xff00CCDD),
      ),
      body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 280,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ExpansionTile(
                      collapsedBackgroundColor: const Color(0xff00CCDD),
                      backgroundColor: Colors.cyanAccent,
                      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                      title: const Text('Sound'),
                      children: [
                        Slider(
                          min: 0,
                          max: 100,
                          value: volume,
                          // label:volume.toString(),
                          onChanged: (double value) {
                            setState(() {
                              volume = value;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 280,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ExpansionTile(
                      collapsedBackgroundColor: const Color(0xff00CCDD),
                      backgroundColor: Colors.cyanAccent,
                      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                      title: const Text('Vibration'),
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
                ),
                SizedBox(
                  width: 280,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ExpansionTile(
                      collapsedBackgroundColor: const Color(0xff00CCDD),
                      backgroundColor: Colors.cyanAccent,
                      expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                      title: const Text('Contact Us'),
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
                                            text: '@R_mmawn'));
                                      },
                                      child: const Icon(
                                        Icons.content_copy,
                                        size: 22,
                                      )),
                                ],
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Instagramn'),
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
                                            const ClipboardData(text: 'arm.wan'));
                                      },
                                      child: const Icon(
                                        Icons.content_copy,
                                        size: 22,
                                      )),
                                ],
                              ),
                              const SizedBox(
                                height: 2,
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
                                height: 6,
                              ),
                              const Text('Made With ❤️ By Rmaan'),
                              const Text('v0.10')
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}