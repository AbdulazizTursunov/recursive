import 'package:flutter/material.dart';
import 'view.dart';

class ContactDbScreen extends StatefulWidget {
  const ContactDbScreen({super.key});

  @override
  State<ContactDbScreen> createState() => _ContactDbScreenState();
}

class _ContactDbScreenState extends State<ContactDbScreen> {
  TextEditingController nomiController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  List<ContactModel> contactList = [];

  _selectAllContact() {
    setState(() {
      contactList = ContactModel.obektlar.values.toList();
    });
  }

  _obektContactModel() async {
    ContactModel.obektlar = (await ContactModel.service.select())
        .map((key, value) => MapEntry(key, ContactModel.fromJson(value)));
    _selectAllContact();
  }

  @override
  void initState() {
    _obektContactModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Db Contacts"),
      ),
      body: ListView.builder(
        itemCount: contactList.length,
        itemBuilder: (context, index) {
          ContactModel item = contactList[index];
          return Column(
            children: [
              ListTile(
                title: Row(
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        nomiController.text = item.name;
                        numberController.text = item.contact.toString();
                        showDialog(context: context, builder: (context){
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
                              const SizedBox(height: 5),
                              TextField(
                                keyboardType: TextInputType.number,
                                controller: numberController,
                                autofocus: true,
                                decoration: InputDecoration(
                                    hintText: numberController.text,
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
                                  item.name = nomiController.text;
                                  item.contact = numberController.text;
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
                        });
                      },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.yellow,
                      ),
                    )
                  ],
                ),
                subtitle: Row(
                  children: [
                    Text(
                      item.contact.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: ()async {
                       await item.delete();
                        _selectAllContact();
                        setState(() {
                        });
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
              const Divider(),
            ],
          );
        },
      ),
    );
  }
}
