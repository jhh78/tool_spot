import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class OpenAiAndAssistantsProvider {
  final String apiKey;
  final String assistantId;

  OpenAiAndAssistantsProvider({
    required this.apiKey,
    required this.assistantId,
  });

  Map<String, String> getHeaderInfo() {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
      'OpenAI-Beta': 'assistants=v2',
    };
  }

  Future<Map<String, dynamic>> createThread() async {
    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/threads"),
      headers: getHeaderInfo(),
    );

    return json.decode(utf8.decode(response.bodyBytes));
  }

  Future<void> sendMessage(String threadId, String message) async {
    await http.post(
      Uri.parse("https://api.openai.com/v1/threads/$threadId/messages"),
      headers: getHeaderInfo(),
      body: json.encode({
        'role': 'user',
        'content': message,
      }),
    );
  }

  Future<Map<String, dynamic>> createRun(String threadId) async {
    final response = await http.post(
      Uri.parse("https://api.openai.com/v1/threads/$threadId/runs"),
      headers: getHeaderInfo(),
      body: json.encode({"assistant_id": assistantId}),
    );

    return json.decode(utf8.decode(response.bodyBytes));
  }

  Future<Map<String, dynamic>> retrieveRun(String threadId, String runId) async {
    final response = await http.get(
      Uri.parse("https://api.openai.com/v1/threads/$threadId/runs/$runId"),
      headers: getHeaderInfo(),
    );

    return json.decode(utf8.decode(response.bodyBytes));
  }

  Future<Map<String, dynamic>> retrieveMessages(String threadId) async {
    final response = await http.get(
      Uri.parse("https://api.openai.com/v1/threads/$threadId/messages"),
      headers: getHeaderInfo(),
    );

    return json.decode(utf8.decode(response.bodyBytes));
  }

  Future<String> executeQuery(String message) async {
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
