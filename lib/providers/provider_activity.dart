import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpodhowto/models/activity.dart';

final providerActivity = FutureProvider.autoDispose<Activity>((ref) async {
  // Usando il package http, otteniamo un'attività casuale dalle Bored API
  final response = await http.get(Uri.https('boredapi.com', '/api/activity'));
  // Usando dart:convert, decodifichiamo il payload JSON in una Map.
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  // Infine, convertiamo la mappa in un'istanza Activity
  return Activity.fromJson(json);
});
