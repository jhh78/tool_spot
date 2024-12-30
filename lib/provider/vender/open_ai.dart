import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

const String apiKey =
    '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';
const String assistantId = 'asst_O9fBVFkYMvsuBKZcLJrqT7w8';

class OpenAIProvider extends GetxController {
  final Map<String, String> heasers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
    'OpenAI-Beta': 'assistants=v2',
  };

  Future<Map<String, dynamic>> createThread() async {
    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/threads"),
      headers: heasers,
    );

    return json.decode(utf8.decode(response.bodyBytes));
  }

  Future<void> sendMessage(String threadId, String message) async {
    await http.post(
      Uri.parse("https://api.openai.com/v1/threads/$threadId/messages"),
      headers: heasers,
      body: json.encode({
        'role': 'user',
        'content': message,
      }),
    );
  }

  Future<Map<String, dynamic>> createRun(String threadId) async {
    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/threads/$threadId/runs"),
      headers: heasers,
      body: json.encode({"assistant_id": assistantId}),
    );

    return json.decode(utf8.decode(response.bodyBytes));
  }

  Future<Map<String, dynamic>> retrieveRun(String threadId, String runId) async {
    final response = await http.get(
      Uri.parse("https://api.openai.com/v1/threads/$threadId/runs/$runId"),
      headers: heasers,
    );

    return json.decode(utf8.decode(response.bodyBytes));
  }

  Future<Map<String, dynamic>> retrieveMessages(String threadId) async {
    final response = await http.get(
      Uri.parse("https://api.openai.com/v1/threads/$threadId/messages"),
      headers: heasers,
    );

    return json.decode(utf8.decode(response.bodyBytes));
  }

  Future<String> translate(String message) async {
    final threadInfo = await createThread();
    await sendMessage(threadInfo['id'], message);
    final runInfo = await createRun(threadInfo['id']);

    while (true) {
      log('Retrieving');
      final retrieveInfo = await retrieveRun(threadInfo['id'], runInfo['id']);
      await Future.delayed(const Duration(seconds: 1));

      if (retrieveInfo['status'] == 'completed') {
        final responseInfo = await retrieveMessages(threadInfo['id']);

        return responseInfo["data"][0]["content"][0]['text']['value'];
      }
    }
  }
}
