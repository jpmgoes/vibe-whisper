import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class GroqService {
  final http.Client _client = http.Client();

  Future<String> transcribeAudio(String apiKey, String audioFilePath, String whisperModel) async {
    final uri = Uri.parse('https://api.groq.com/openai/v1/audio/transcriptions');
    debugPrint('[GroqService] Transcribe Audio Request URL: $uri');
    
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $apiKey'
      ..fields['model'] = whisperModel
      ..fields['temperature'] = '0'
      ..fields['response_format'] = 'json';
      
    debugPrint('[GroqService] Transcribe Audio Headers: ${request.headers}');
    debugPrint('[GroqService] Transcribe Audio Fields: ${request.fields}');

    request.files.add(await http.MultipartFile.fromPath('file', audioFilePath));
    debugPrint('[GroqService] Transcribe Audio File attached: $audioFilePath');

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    
    debugPrint('[GroqService] Transcribe Audio Response Status: ${response.statusCode}');
    debugPrint('[GroqService] Transcribe Audio Response Body: $responseBody');

    if (response.statusCode != 200) {
      throw Exception('Transcription failed: $responseBody');
    }

    final data = jsonDecode(responseBody);
    return data['text'] as String;
  }

  // ---------------------------------------------------------------------------
  // INTENT DETECTION
  // ---------------------------------------------------------------------------
  Future<Map<String, dynamic>> determineIntent(String apiKey, String text, String intentModel, List<String> snippetKeys) async {
    final uri = Uri.parse('https://api.groq.com/openai/v1/chat/completions');
    debugPrint('[GroqService] Determine Intent Request URL: $uri');
    
    final keysStr = snippetKeys.isEmpty ? "none" : snippetKeys.join(", ");

    final bodyStr = jsonEncode({
      "model": intentModel,
      "temperature": 0.0,
      "max_tokens": 150,
      "top_p": 1,
      "response_format": {"type": "json_object"},
      "messages": [
        {
          "role": "system",
          "content": "You are an intent router. Your job is to analyze transcriptions and output JSON.\n"
                     "Actions:\n"
                     "1. 'snippet': if the user's spoken text asks to type/insert a snippet that matches one of these existing keys: [$keysStr].\n"
                     "2. 'translate': if the user's spoken text starts with a command to translate the text (e.g. 'translate to english').\n"
                     "3. 'treat': if the user just spoke normally and wants the text cleaned.\n\n"
                     "Output a JSON object with this exact schema:\n"
                     "{\n"
                     "  \"action\": \"snippet\" | \"translate\" | \"treat\",\n"
                     "  \"target_language\": \"...\" (only if action is translate, otherwise null),\n"
                     "  \"snippet_key\": \"...\" (only if action is snippet, otherwise null)\n"
                     "}"
        },
        {
          "role": "user",
          "content": text
        }
      ]
    });

    final response = await _client.post(
      uri,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: bodyStr,
    );

    if (response.statusCode != 200) {
      debugPrint('[GroqService] Intent detection failed, defaulting to treat: ${response.body}');
      return {"action": "treat", "target_language": null};
    }

    try {
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'] as String;
      return jsonDecode(content) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('[GroqService] Failed to parse intent JSON, defaulting to treat: $e');
      return {"action": "treat", "target_language": null};
    }
  }

  // ---------------------------------------------------------------------------
  // TEXT TREATMENT & TRANSLATION
  // ---------------------------------------------------------------------------
  Future<String> treatText(String apiKey, String text, String llmModel, {String? targetLanguage}) async {
    final uri = Uri.parse('https://api.groq.com/openai/v1/chat/completions');
    debugPrint('[GroqService] Treat Text Request URL: $uri');

    String systemPrompt = "You are an expert text editor specialized in cleaning up raw speech-to-text transcripts. Your goal is to transform messy, spontaneous spoken language into clear, concise, and fluid text while preserving the speaker's original intent, tone, and language.\n\nFollow these rules strictly:\n1. **Resolve Self-Corrections:** If the speaker makes a mistake and corrects themselves (e.g., wrong name, wrong time), output ONLY the final corrected intent.\n2. **Remove Filler & Disfluencies:** Eliminate false starts, stutters, and filler words like \"um\", \"uh\", \"you know\", \"like\".\n3. **Remove Meta-Talk:** Delete phrases the speaker uses to manage their own speech, such as \"scratch that\", \"I meant\", \"as you can see\", or \"let me start over\".\n4. **Preserve the Core Message and Tone:** Keep the exact meaning and the casual or formal tone of the original message. Do not summarize the text; rewrite it as if the speaker had spoken perfectly the first time.\n5. **Fix Formatting:** Ensure proper punctuation and capitalization.\n6. **No Yapping:** Output ONLY the cleaned text. Do not include introductory phrases like \"Here is the cleaned text:\" or any explanations.";

    if (targetLanguage != null && targetLanguage.isNotEmpty) {
      systemPrompt += "\n\nCRITICAL INSTRUCTION: The user has requested to translate this text. You must apply all the cleaning rules above, but output the final processed text TRANSLATED INTO $targetLanguage.";
    }

    final bodyStr = jsonEncode({
      "model": llmModel,
      "temperature": 0.6,
      "max_tokens": 4096,
      "top_p": 1,
      "messages": [
        {
          "role": "system",
          "content": systemPrompt
        },
        {
          "role": "user",
          "content": text
        }
      ]
    });
    
    debugPrint('[GroqService] Treat Text Headers: {Authorization: Bearer ***, Content-Type: application/json}');
    debugPrint('[GroqService] Treat Text Body: $bodyStr');

    final response = await _client.post(
      uri,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: bodyStr,
    );

    debugPrint('[GroqService] Treat Text Response Status: ${response.statusCode}');
    debugPrint('[GroqService] Treat Text Response Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Treatment failed: ${response.body}');
    }

    final data = jsonDecode(response.body);
    final choices = data['choices'] as List;
    if (choices.isNotEmpty) {
      return choices[0]['message']['content'] as String;
    }
    throw Exception('No valid completion returned');
  }

  Future<List<String>> getAvailableModels(String apiKey) async {
    final uri = Uri.parse('https://api.groq.com/openai/v1/models');
    debugPrint('[GroqService] Get Available Models URL: $uri');
    debugPrint('[GroqService] Get Available Models Headers: {Authorization: Bearer ***, Content-Type: application/json}');

    final response = await _client.get(
      uri,
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
    );

    debugPrint('[GroqService] Get Available Models Response Status: ${response.statusCode}');
    debugPrint('[GroqService] Get Available Models Response Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch models: ${response.body}');
    }

    final data = jsonDecode(response.body);
    final models = data['data'] as List;
    return models.map((m) => m['id'] as String).toList();
  }
}
