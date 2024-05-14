import 'package:all_in_one/styles/app_style.dart';
import 'package:flutter/material.dart';
import 'package:all_in_one/src/rust/llm/plugins/chat_db.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'db_notifier.dart';

class AddDbDialog extends ConsumerStatefulWidget {
  const AddDbDialog({super.key});

  @override
  ConsumerState<AddDbDialog> createState() => _AddDbDialogState();
}

class _AddDbDialogState extends ConsumerState<AddDbDialog> {
  final _formKey = GlobalKey<FormState>();

  /// 这里缺少db类型，不过暂时只支持mysql
  // final DatabaseType dbType = DatabaseType.mysql;
  final TextEditingController dbNameController = TextEditingController();
  final dbNameNode = FocusNode();
  final TextEditingController dbAddressController = TextEditingController();
  final dbAddressNode = FocusNode();
  final TextEditingController dbPortController = TextEditingController();
  final dbPortNode = FocusNode();
  final TextEditingController dbUsernameController = TextEditingController();
  final dbUsernameNode = FocusNode();
  final TextEditingController dbPasswordController = TextEditingController();
  final dbPasswordNode = FocusNode();
  final TextEditingController dbDatabaseController = TextEditingController();
  final dbDatabaseNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    dbAddressController.dispose();
    dbPortController.dispose();
    dbUsernameController.dispose();
    dbPasswordController.dispose();
    dbDatabaseController.dispose();
    dbNameController.dispose();
    dbNameNode.dispose();
    dbAddressNode.dispose();
    dbDatabaseNode.dispose();
    dbPortNode.dispose();
    dbUsernameNode.dispose();
    dbPasswordNode.dispose();
  }

  final Color textColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 300,
        height: 350,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                _wrapper(
                    "connect name",
                    TextFormField(
                      validator: (value) {
                        if (value == null || value == "") {
                          return "";
                        }
                        return null;
                      },
                      controller: dbNameController,
                      style: TextStyle(color: textColor, fontSize: 12),
                      decoration: AppStyle.inputDecoration,
                      autofocus: true,
                      onFieldSubmitted: (value) {
                        dbAddressNode.requestFocus();
                      },
                    )),
                const SizedBox(
                  height: 10,
                ),
                _wrapper(
                    "address",
                    TextFormField(
                      validator: (value) {
                        if (value == null || value == "") {
                          return "";
                        }
                        return null;
                      },
                      controller: dbAddressController,
                      style: TextStyle(color: textColor, fontSize: 12),
                      decoration: AppStyle.inputDecoration,
                      autofocus: false,
                      onFieldSubmitted: (value) {
                        dbPortNode.requestFocus();
                      },
                    )),
                const SizedBox(
                  height: 10,
                ),
                _wrapper(
                    "port",
                    TextFormField(
                      validator: (value) {
                        if (value == null ||
                            value == "" ||
                            int.tryParse(value) == null) {
                          return "";
                        }
                        return null;
                      },
                      controller: dbPortController,
                      style: TextStyle(color: textColor, fontSize: 12),
                      decoration: AppStyle.inputDecoration,
                      autofocus: false,
                      onFieldSubmitted: (value) {
                        dbUsernameNode.requestFocus();
                      },
                    )),
                const SizedBox(
                  height: 10,
                ),
                _wrapper(
                    "username",
                    TextFormField(
                      validator: (value) {
                        if (value == null || value == "") {
                          return "";
                        }
                        return null;
                      },
                      controller: dbUsernameController,
                      style: TextStyle(color: textColor, fontSize: 12),
                      decoration: AppStyle.inputDecoration,
                      autofocus: false,
                      onFieldSubmitted: (value) {
                        dbPasswordNode.requestFocus();
                      },
                    )),
                const SizedBox(
                  height: 10,
                ),
                _wrapper(
                    "password",
                    TextFormField(
                      validator: (value) {
                        if (value == null || value == "") {
                          return "";
                        }
                        return null;
                      },
                      controller: dbPasswordController,
                      style: TextStyle(color: textColor, fontSize: 12),
                      decoration: AppStyle.inputDecoration,
                      autofocus: false,
                      onFieldSubmitted: (value) {
                        dbDatabaseNode.requestFocus();
                      },
                    )),
                const SizedBox(
                  height: 10,
                ),
                _wrapper(
                    "db name",
                    TextFormField(
                      validator: (value) {
                        if (value == null || value == "") {
                          return "";
                        }
                        return null;
                      },
                      controller: dbDatabaseController,
                      style: TextStyle(color: textColor, fontSize: 12),
                      decoration: AppStyle.inputDecoration,
                      autofocus: false,
                      onFieldSubmitted: (value) {
                        _submit();
                      },
                    )),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    ElevatedButton(
                        onPressed: () {
                          _submit();
                        },
                        child: const Text("OK"))
                  ],
                )
              ],
            )),
      ),
    );
  }

  _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    DatabaseInfo databaseInfo = DatabaseInfo(
        name: dbNameController.text,
        address: dbAddressController.text,
        port: dbPortController.text,
        username: dbUsernameController.text,
        password: dbPasswordController.text,
        database: dbDatabaseController.text);
    ref.read(dbNotifierProvider.notifier).addDatasource(databaseInfo);
    Navigator.of(context).pop();
  }

  _wrapper(String title, Widget child) {
    return SizedBox(
      height: 35,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(title),
          ),
          Expanded(
              child: Align(
            alignment: Alignment.centerLeft,
            child: child,
          ))
        ],
      ),
    );
  }
}
