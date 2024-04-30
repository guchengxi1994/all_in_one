import 'package:all_in_one/src/rust/api/process_port_mapper_api.dart';
import 'package:all_in_one/src/rust/system_monitor.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluto_grid/pluto_grid.dart';

class NetstatManagerScreen extends ConsumerStatefulWidget {
  const NetstatManagerScreen({super.key});

  @override
  ConsumerState<NetstatManagerScreen> createState() =>
      _NetstatManagerScreenState();
}

class _NetstatManagerScreenState extends ConsumerState<NetstatManagerScreen> {
  List<ProcessPortMapper> data = [];

  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];

  @override
  void initState() {
    super.initState();
    columns = [
      PlutoColumn(
        width: 80,
        title: 'id',
        field: 'id',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'pid',
        field: 'pid',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'port',
        field: 'port',
        type: PlutoColumnType.number(),
      ),
      PlutoColumn(
        title: 'status',
        field: 'status',
        type: PlutoColumnType.text(),
      ),
      PlutoColumn(
        title: 'process name',
        field: 'process_name',
        type: PlutoColumnType.text(),
      ),
    ];
    future = _fetchData();
  }

  // ignore: prefer_typing_uninitialized_variables
  var future;

  _fetchData() async {
    data.clear();
    data = await getProcessPortMappers();
    rows = data
        .mapIndexed((i, e) => PlutoRow(cells: {
              "id": PlutoCell(value: i + 1),
              "pid": PlutoCell(value: e.pid),
              "port": PlutoCell(value: e.localPort),
              "status": PlutoCell(value: e.status),
              "process_name": PlutoCell(value: e.processName),
            }))
        .toList();
  }

  late PlutoGridStateManager stateManager;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () async {
          stateManager.removeAllRows();
          await _fetchData();
          stateManager.insertRows(0, rows, notify: true);
        },
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder(
            future: future,
            builder: (c, s) {
              if (s.connectionState == ConnectionState.done) {
                return PlutoGrid(
                  columns: columns,
                  rows: rows,
                  onLoaded: (event) {
                    stateManager = event.stateManager;
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}
