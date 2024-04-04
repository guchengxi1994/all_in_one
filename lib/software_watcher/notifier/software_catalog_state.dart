import 'package:all_in_one/isar/software.dart';

class SoftwareCatalogState {
  List<SoftwareCatalog> catalogs;
  int current;

  SoftwareCatalogState({this.catalogs = const [], this.current = 1});
}
