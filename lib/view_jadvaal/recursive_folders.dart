import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_iconpicker_plus/flutter_iconpicker.dart';
import 'package:recursive/data/model/jadval_model.dart';
import 'package:recursive/generated/locale_keys.g.dart';

class RecursiveFoldersView extends StatefulWidget {
  const RecursiveFoldersView(
      {super.key, required this.jadval, required this.folder});

  final Jadval jadval;
  final String folder;

  @override
  State<RecursiveFoldersView> createState() => _RecursiveFoldersViewState();
}

class _RecursiveFoldersViewState extends State<RecursiveFoldersView> {
  Icon? iconData;
  TextEditingController nomiController = TextEditingController();
  List<Jadval> listJadval = [];

  //localization
  String dropdownvalue = 'uz';
  var items = [
    'uz',
    'en',
    'ru',
  ];

  _pickIcon() async {
    IconData? icon = await FlutterIconPicker.showIconPicker(context,
        iconPackModes: [IconPack.material]);
    iconData = Icon(icon);
    setState(() {});
    debugPrint('Picked Icon:  $icon');
  }

  _selectAllFolder() {
    listJadval.clear();
    listJadval = [];
    listJadval = Jadval.obektlar.values
        .where((element) => element.trBobo == widget.jadval.tr)
        .toList();
    setState(() {
      listJadval;
    });
  }

  _obektJadvalModel() async {
    Jadval.obektlar = (await Jadval.service.select())
        .map((key, value) => MapEntry(key, Jadval.fromJson(value)));
    await _selectAllFolder();
  }

  @override
  void initState() {
    _obektJadvalModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          DropdownButton(
            value: dropdownvalue,
            icon: const Icon(Icons.language),
            items: items.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                dropdownvalue = newValue!;
                context.setLocale(Locale(newValue));
              });
            },
          ),
          const SizedBox(width: 5),
        ],
        title: Text(
          widget.folder,
          style: Theme.of(context).textTheme.titleSmall,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: listJadval.length,
              itemBuilder: (context, index) {
                Jadval item = listJadval[index];
                debugPrint(item.toString());
                return ListTile(
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        nomiController.text = item.nomi;
                        return AlertDialog(
                          title: Text(LocaleKeys.Editing.tr()),
                          actions: [
                            TextField(
                              controller: nomiController,
                              autofocus: true,
                              decoration: InputDecoration(
                                  hintText: nomiController.text,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  fillColor: Colors.blueAccent),
                            ),
                            const SizedBox(height: 10),
                            TextButton(
                              onPressed: () async {
                                item.nomi = nomiController.text;
                                await item.update();
                                nomiController.clear();
                                setState(() {});
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
                              },
                              child: Text(LocaleKeys.Ok.tr(),
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecursiveFoldersView(
                          jadval: item,
                          folder: "${widget.folder}${item.nomi}/",
                        ),
                      ),
                    );
                  },
                  title: Row(
                    children: [
                      Text(
                        item.nomi,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontSize: 20),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(LocaleKeys.Unlist_folders.tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                actions: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(LocaleKeys.Cansel.tr(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium),
                                      ),
                                      const SizedBox(width: 10),
                                      TextButton(
                                        onPressed: () async {
                                          await item.delete();
                                          await _selectAllFolder();
                                          setState(() {});
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(LocaleKeys.Ok.tr(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      )
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Text(item.time.toString().substring(0,16)),
                      const Spacer(),
                      Icon(
                        IconData(
                          int.tryParse(item.iconData) ?? Icons.warning.codePoint,
                          fontFamily: "MaterialIcons",
                        ),
                        color: item.color,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _animationDialog(context);
        },
        backgroundColor: Colors.cyan,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _animationDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, a1, a2, widget1) {
        return ScaleTransition(
          alignment: Alignment.bottomRight,
          scale: Tween<double>(begin: 0.25, end: 1.0).animate(a1),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.5, end: 1.0).animate(a1),
            child: AlertDialog(
              title: Text("Add_folder".tr()),
              actions: [
                SizedBox(
                  height: 50,
                  child: TextField(
                    controller: nomiController,
                    autofocus: true,
                    decoration: InputDecoration(
                        hintText: LocaleKeys.name.tr(),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        fillColor: Colors.blueAccent),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('rang tanlang!'),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: pickerColor,
                                  onColorChanged: changeColor,
                                ),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('Got it'),
                                  onPressed: () {
                                    setState(() => currentColor = pickerColor);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text("color"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        _pickIcon();
                      },
                      child: const Text("icon"),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: iconData ?? Container(),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(LocaleKeys.Cansel.tr()),
                    ),
                    TextButton(
                      onPressed: () async {
                        Jadval jadval = Jadval();
                        jadval.trBobo = widget.jadval.tr;
                        jadval.nomi = nomiController.text;
                        jadval.color = currentColor;
                        jadval.time = DateTime.now();
                        jadval.iconData = iconData!.icon!.codePoint.toString();
                        await jadval.insert();
                        await _selectAllFolder();
                        nomiController.clear();
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      },
                      child: Text(LocaleKeys.Add_folder.tr()),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }
}
