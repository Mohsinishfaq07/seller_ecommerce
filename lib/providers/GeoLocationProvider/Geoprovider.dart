import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final geoLocationProvider = StateNotifierProvider<GeoLocationNotifier, List<String>>((ref) {
  return GeoLocationNotifier();
});

class GeoLocationNotifier extends StateNotifier<List<String>> {
  GeoLocationNotifier() : super([]);

  static const _apiKey = 'YOUR_GEOAPIFY_API_KEY'; // Replace with your actual key
  final Map<String, List<String>> _cache = {}; // 🔒 In-memory cache

  Future<void> fetchAddressSuggestions(String query) async {
    final cleanQuery = query.trim().toLowerCase();
    if (cleanQuery.isEmpty) return;

    // 🔍 Return from cache if available
    if (_cache.containsKey(cleanQuery)) {
      state = _cache[cleanQuery]!;
      return;
    }

    final url = Uri.parse(
      'https://api.geoapify.com/v1/geocode/autocomplete?text=$cleanQuery&filter=countrycode:pk&limit=10&apiKey=2bc7c27d5531410b85f2c68eeec6b439',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['features'] as List<dynamic>;
        final suggestions = results
            .map((feature) => feature['properties']['formatted'] as String)
            .toList();

        // 🧠 Cache the result
        _cache[cleanQuery] = suggestions;

        state = suggestions;
      } else {
        print("Geoapify API error: ${response.statusCode}");
      }
    } catch (e) {
      print("Geoapify API exception: $e");
    }
  }
}
