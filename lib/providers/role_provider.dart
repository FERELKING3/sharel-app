import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TransferRole { sender, receiver }

final transferRoleProvider = StateProvider<TransferRole?>((ref) => null);
