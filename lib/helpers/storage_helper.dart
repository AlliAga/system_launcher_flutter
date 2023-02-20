import 'package:storage_info/storage_info.dart';

class StorageHelper {
  StorageHelper._();

  static final StorageHelper init = StorageHelper._();

  Future<double> get getStorageTotalSpaceInGB async =>
      await StorageInfo.getStorageTotalSpaceInGB;

  Future<double> get getStorageUsedSpaceInGB async =>
      await StorageInfo.getStorageUsedSpaceInGB;

  Future<double> get getStorageFreeSpaceInGB async =>
      await StorageInfo.getStorageFreeSpaceInGB;

  Future<double> get getCalculatedSpace async =>
      1 - (await getStorageUsedSpaceInGB / await getStorageTotalSpaceInGB);
}
