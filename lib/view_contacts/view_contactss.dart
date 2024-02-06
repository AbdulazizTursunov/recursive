import 'view.dart';
import 'package:flutter/material.dart';

class ContactsView extends StatefulWidget {
  const ContactsView({super.key});

  @override
  State<ContactsView> createState() => _ContactsViewState();
}

class _ContactsViewState extends State<ContactsView> {
  List<Contact> contact = [];
  bool isLoading = true;
  bool isSelected = false;
  bool add = false;
  bool check = false;

  void getContactPermission() async {
    if (await Permission.contacts.isGranted) {
      fetchContacts();
    } else {
      await Permission.contacts.request();
    }
  }

  void fetchContacts() async {
    contact = await ContactsService.getContacts();
    debugPrint("contactlar listga o'tdi");
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getContactPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Contacts",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: contact.length,
              itemBuilder: (context, index) {
                Contact item = contact[index];
                return ListTile(
                  onLongPress: () async {
                    setState(() {
                      isSelected = !isSelected;
                    });
                  },
                  onTap: () {
                    isSelected
                        ? null
                        : showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Text(
                                    "${item.givenName!} bazaga saqlansinmi ?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(LocaleKeys.Cansel.tr()),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      ContactModel contactModel =
                                          ContactModel();
                                      contactModel.name = item.givenName!;
                                      contactModel.contact =
                                          item.phones!.first.value!;
                                      await contactModel.insert();
                                      setState(() {});
                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(LocaleKeys.Ok.tr()),
                                  ),
                                ],
                              );
                            },
                          );
                  },
                  trailing: isSelected ? RoundCheckBox(
                      size: 24,
                      onTap: (v)async{
                    debugPrint("=========================================pressed");
                    ContactModel contactModel = ContactModel();
                    contactModel.name = item.givenName!;
                    contactModel.contact =  item.phones!.first.value!;
                    add?  await  contactModel.insert():null;
                    setState(() {});
                  }):null,

                  title: Text(
                    item.givenName!,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),         
                  subtitle: Text(
                    (item.phones != null && item.phones!.isNotEmpty)
                        ? item.phones!.first.value!.toString()
                        : "Telefon mavjud emas",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w400),
                  ),
                  leading: Text(
                    (item.givenName != null && item.givenName!.isNotEmpty)
                        ? item.givenName![0].toString()
                        : "A",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                );
              },
            ),
      floatingActionButton: isSelected
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton.extended(
                  onPressed: () {
                    setState(() {
                      isSelected = !isSelected;
                    });
                  },
                  label: Row(
                    children: [
                      const Icon(Icons.backpack),
                      const SizedBox(width: 10),
                      Text(
                        LocaleKeys.Cansel.tr(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 15),
                FloatingActionButton.extended(
                  onPressed: () {
                    setState(() {
                      isSelected = !isSelected;
                      add = !add;
                    });
                  },
                  label: Row(
                    children: [
                      const Icon(Icons.add),
                      const SizedBox(width: 10),
                      Text(
                        LocaleKeys.Added.tr(),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ContactDbScreen(),
                  ),
                );
              },
              label: const Text("Bazani ko'rish")),
    );
  }
}
