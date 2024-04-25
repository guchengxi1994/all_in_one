import 'package:all_in_one/src/rust/api/process_port_mapper_api.dart';
import 'package:all_in_one/src/rust/system_monitor.dart';
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

  @override
  void initState() {
    super.initState();
    columns = [
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

  var future;

  _fetchData() async {
    data = await getProcessPortMappers();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: FutureBuilder(
          future: future,
          builder: (c, s) {
            if (s.connectionState == ConnectionState.done) {
              return PlutoGrid(
                columns: columns,
                rows: data
                    .map((e) => PlutoRow(cells: {
                          "pid": PlutoCell(value: e.pid),
                          "port": PlutoCell(value: e.localPort),
                          "status": PlutoCell(value: e.status),
                          "process_name": PlutoCell(value: e.processName),
                        }))
                    .toList(),
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
