import '../enumeration/qr_data_type.dart';

class ScanResults {
  final QrDataType scanResultType;
  final String data;

  const ScanResults(this.scanResultType, this.data);
}
