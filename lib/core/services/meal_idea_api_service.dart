import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MealIdeaApiService {
  static Future<List<String>> getMealIdeas(String prompt) async {
    final key = dotenv.env['GROQ_API_KEY'];

    if (key == null) {
      throw Exception("Missing API Key!");
    }

    final response = await http.post(
      Uri.parse("https://api.groq.com/openai/v1/chat/completions"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $key",
      },
      body: jsonEncode({
        "model": "llama-3.1-8b-instant",
        "messages": [
          {
            "role": "user",
            "content":
            "You are a meal-planning assistant. Give me 5 meal ideas based on the request below. Return ONLY the meal names, each meal name separated by one comma and one space (normal english grammar), with no numbering, no bullets, and no extra text. Request: {$prompt}"
          }
        ]
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("API error: ${response.body}");
    }

    final data = jsonDecode(response.body);
    final String text = data["choices"][0]["message"]["content"];

    return text.split(", ");
  }
}
