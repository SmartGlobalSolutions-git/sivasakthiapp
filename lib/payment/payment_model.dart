class ChitItem {
  final String chitId;
  final String name;
  final String groupDetail;
  final String role;
  final String chitValue;
  final String dateRange;
  final String runningBalance;
  final String acNo;
  final String upiId;
  final String status;
  final int chitAmount;
  final int dueAmount;

  const ChitItem({
    required this.chitId,
    required this.name,
    required this.groupDetail,
    required this.role,
    required this.chitValue,
    required this.dateRange,
    required this.runningBalance,
    required this.acNo,
    required this.upiId,
    required this.status,
    required this.chitAmount,
    required this.dueAmount,
  });

  // Figma: Due 20,000 -> default 10,000 | Due 30,000 -> default 15,000
  int get defaultPayAmount => dueAmount ~/ 2;
}

class ChitPayItem {
  final ChitItem chit;
  final int payingAmount;

  const ChitPayItem({
    required this.chit,
    required this.payingAmount,
  });
}

/// 100000 -> 1,00,000
String formatInr(int value) {
  final String s = value.abs().toString();
  if (s.length <= 3) return s;
  final String last3 = s.substring(s.length - 3);
  String rest = s.substring(0, s.length - 3);
  final List<String> parts = <String>[];
  while (rest.length > 2) {
    parts.insert(0, rest.substring(rest.length - 2));
    rest = rest.substring(0, rest.length - 2);
  }
  if (rest.isNotEmpty) parts.insert(0, rest);
  return '${parts.join(',')},$last3';
}

// TODO: replace with API data
const List<ChitItem> sampleChits = [
  ChitItem(
    chitId: '12345',
    name: 'Chandru',
    groupDetail: '10-L',
    role: 'Customer',
    chitValue: '10,00,000',
    dateRange: '10 Jan 26 - 10 Dec 26',
    runningBalance: '5,00,000',
    acNo: '10108011866',
    upiId: '10108011866@ubicaps',
    status: 'Running',
    chitAmount: 100000,
    dueAmount: 20000,
  ),
  ChitItem(
    chitId: '12345',
    name: 'Chandru',
    groupDetail: '10-L',
    role: 'Customer',
    chitValue: '10,00,000',
    dateRange: '10 Jan 26 - 10 Dec 26',
    runningBalance: '5,00,000',
    acNo: '10108011866',
    upiId: '10108011866@ubicaps',
    status: 'Running',
    chitAmount: 200000,
    dueAmount: 30000,
  ),
  ChitItem(
    chitId: '12345',
    name: 'Chandru',
    groupDetail: '10-L',
    role: 'Customer',
    chitValue: '10,00,000',
    dateRange: '10 Jan 26 - 10 Dec 26',
    runningBalance: '5,00,000',
    acNo: '10108011866',
    upiId: '10108011866@ubicaps',
    status: 'Running',
    chitAmount: 100000,
    dueAmount: 20000,
  ),
];