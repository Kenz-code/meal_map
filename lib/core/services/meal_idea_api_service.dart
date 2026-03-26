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
            "role": "system",
            "content":
            "You are a meal-planning assistant. When asked for meal ideas, "
                "respond with exactly 5 meal names — one per line, numbered 1 to 5 "
                "in the format '1. Meal Name'. No extra text, no descriptions, "
                "no blank lines, nothing before or after the list.",
          },
          {
            "role": "user",
            "content": prompt,
          }
        ]
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("API error: ${response.body}");
    }

    final data = jsonDecode(response.body);
    final String text = data["choices"][0]["message"]["content"];

    return text
        .trim()
        .split('\n')
        .map((line) => line.replaceFirst(RegExp(r'^\d+\.\s*'), '').trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }
}
