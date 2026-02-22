Quero um projeto em flutter nessa pasta/workspace para desktop que seja um whisper, ao pressionar algum shortcut no mac|windows|linux deve começar a escutar o audio do usuário, mandar esse audio para o whisper, pegar a resposta em texto e mandar para a IA de tratamento, então deve colar no clipboard a resposta da IA de tratamento.
Por o projeto ser opensource e gratuito e usuário tem que colocar suas próprias chaves de API para funcionar
O usuário precisa apertar o shortcut para começar a escutar e apertar novamente para parar de escutar.
A chave do usuário precisa ser mantidade em local seguro e não pode aparecer nem em log nem completa no perfil, apenas mascarada.

Use o design do google stich como referencia @mcp:StitchMCP: https://stitch.withgoogle.com/projects/65833930409438560

O projeto deve poder ter vário idiomas o usuário pode escolher o idioma do app, o do whisper separadamente sempre será auto detect. 
O projeto deve pegar o idioma pelo sistema operacional para Intl
O app deve ter traduções para en, pt, es

nas configurações o usuário pode decidir se vai apenas copiar apenas para o área de transferência ou se vai colar no campo ativo também.

O app precisa ter darkmode e lightmode

o usuário pode seleciona o modelo de tratmento e o modelo de whisper, atualmente só tem dois de whisper

o default de tratamento deve ser o kimi e o default de whisper deve ser o turbo

se o usuário não conseguir resposta por ter batido limite ou tiver error da api deve notificar no sistema e dentro do app

# Tratamento

## request
```bash
curl https://api.groq.com/openai/v1/chat/completions \
  -H "Authorization: Bearer $GROQ_API_KEY" \
  -H "Content-Type: application/json" \
  -d @- <<EOF
{
  "model": "llama-3.3-70b-versatile",
  "temperature": 0.6,
  "max_tokens": 4096,
  "top_p": 1,
  "messages": [
    {
      "role": "system",
      "content": "You are an expert text editor specialized in cleaning up raw speech-to-text transcripts. Your goal is to transform messy, spontaneous spoken language into clear, concise, and fluid text while preserving the speaker's original intent, tone, and language.\\n\\nFollow these rules strictly:\\n1. **Resolve Self-Corrections:** If the speaker makes a mistake and corrects themselves (e.g., wrong name, wrong time), output ONLY the final corrected intent.\\n2. **Remove Filler & Disfluencies:** Eliminate false starts, stutters, and filler words like \\"um\\", \\"uh\\", \\"you know\\", \\"like\\".\\n3. **Remove Meta-Talk:** Delete phrases the speaker uses to manage their own speech, such as \\"scratch that\\", \\"I meant\\", \\"as you can see\\", or \\"let me start over\\".\\n4. **Preserve the Core Message and Tone:** Keep the exact meaning and the casual or formal tone of the original message. Do not summarize the text; rewrite it as if the speaker had spoken perfectly the first time.\\n5. **Fix Formatting:** Ensure proper punctuation and capitalization.\\n6. **No Yapping:** Output ONLY the cleaned text. Do not include introductory phrases like \\"Here is the cleaned text:\\" or any explanations.\\n\\n### EXAMPLES ###\\n\\nRaw: \\"Hey Mark, how's it going? Sorry I meant John. We should do a call at 3:30 PM. Actually no way to scratch that. Let's do a call at 4 PM as you can see.\\"\\nCleaned: \\"Hey John, how's it going? We should do a call at 4 PM.\\"\\n\\nRaw: \\"So I was thinking we could, um, deploy the new feature on Tuesday. Wait, no, Wednesday makes more sense because of the holiday. Yeah, Wednesday.\\"\\nCleaned: \\"So I was thinking we could deploy the new feature on Wednesday.\\"\\n\\nRaw: \\"Please send the invoice to... give me a second to check... right, send it to the accounting department.\\"\\nCleaned: \\"Please send the invoice to the accounting department.\\""
    },
    {
      "role": "user",
      "content": "Boa tarde, gostaria de falar com fulano, oh, na verdade, quero falar com beltrano para ir pra casa do neto, mals casa do kleiton"
    }
  ]
}
EOF
```

## response
```json
{
  "id": "chatcmpl-8c686338-d508-449b-a7c5-9b774552ccc0",
  "object": "chat.completion",
  "created": 1771791192,
  "model": "moonshotai/kimi-k2-instruct-0905",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "Boa tarde. Quero falar com Beltrano para ir à casa do Kleiton."
      },
      "logprobs": null,
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "queue_time": 0.031793571,
    "prompt_tokens": 121,
    "prompt_time": 0.021939568,
    "completion_tokens": 22,
    "completion_time": 0.052372193,
    "total_tokens": 143,
    "total_time": 0.074311761
  },
  "usage_breakdown": null,
  "system_fingerprint": "fp_6986a421e1",
  "x_groq": { "id": "req_01kj3fr4rqfvzbajj1wqa1fnbe", "seed": 110225358 },
  "service_tier": "on_demand"
}
```

# Whisper

## request
```bash
curl https://api.groq.com/openai/v1/audio/transcriptions \
  -H "Authorization: bearer ${GROQ_API_KEY}" \
  -F "file=@./audio.m4a" \
  -F model=whisper-large-v3-turbo \
  -F temperature=0 \
  -F response_format=json
```

## response
```json
{
  "text": "Boa tarde, gostaria de falar com fulano, oh, na verdade, quero falar com beltrano para ir pra casa do neto, mals casa do kleiton"
}
```


# Models

## request
```bash
curl -X GET "https://api.groq.com/openai/v1/models" \
  -H "Authorization: Bearer $GROQ_API_KEY$" \
  -H "Content-Type: application/json"
```

## response
```json
{
  "object": "list",
  "data": [
    {
      "id": "meta-llama/llama-prompt-guard-2-22m",
      "object": "model",
      "created": 1748632101,
      "owned_by": "Meta",
      "active": true,
      "context_window": 512,
      "public_apps": null,
      "max_completion_tokens": 512
    },
    {
      "id": "allam-2-7b",
      "object": "model",
      "created": 1737672203,
      "owned_by": "SDAIA",
      "active": true,
      "context_window": 4096,
      "public_apps": null,
      "max_completion_tokens": 4096
    },
    {
      "id": "openai/gpt-oss-safeguard-20b",
      "object": "model",
      "created": 1761708789,
      "owned_by": "OpenAI",
      "active": true,
      "context_window": 131072,
      "public_apps": null,
      "max_completion_tokens": 65536
    },
    {
      "id": "canopylabs/orpheus-arabic-saudi",
      "object": "model",
      "created": 1765926439,
      "owned_by": "Canopy Labs",
      "active": true,
      "context_window": 4000,
      "public_apps": null,
      "max_completion_tokens": 50000
    },
    {
      "id": "openai/gpt-oss-20b",
      "object": "model",
      "created": 1754407957,
      "owned_by": "OpenAI",
      "active": true,
      "context_window": 131072,
      "public_apps": null,
      "max_completion_tokens": 65536
    },
    {
      "id": "openai/gpt-oss-120b",
      "object": "model",
      "created": 1754408224,
      "owned_by": "OpenAI",
      "active": true,
      "context_window": 131072,
      "public_apps": null,
      "max_completion_tokens": 65536
    },
    {
      "id": "meta-llama/llama-guard-4-12b",
      "object": "model",
      "created": 1746743847,
      "owned_by": "Meta",
      "active": true,
      "context_window": 131072,
      "public_apps": null,
      "max_completion_tokens": 1024
    },
    {
      "id": "meta-llama/llama-4-maverick-17b-128e-instruct",
      "object": "model",
      "created": 1743877158,
      "owned_by": "Meta",
      "active": true,
      "context_window": 131072,
      "public_apps": null,
      "max_completion_tokens": 8192
    },
    {
      "id": "moonshotai/kimi-k2-instruct",
      "object": "model",
      "created": 1752435491,
      "owned_by": "Moonshot AI",
      "active": true,
      "context_window": 131072,
      "public_apps": null,
      "max_completion_tokens": 16384
    },
    {
      "id": "qwen/qwen3-32b",
      "object": "model",
      "created": 1748396646,
      "owned_by": "Alibaba Cloud",
      "active": true,
      "context_window": 131072,
      "public_apps": null,
      "max_completion_tokens": 40960
    },
    {
      "id": "groq/compound",
      "object": "model",
      "created": 1756949530,
      "owned_by": "Groq",
      "active": true,
      "context_window": 131072,
      "public_apps": null,
      "max_completion_tokens": 8192
    },
    {
      "id": "moonshotai/kimi-k2-instruct-0905",
      "object": "model",
      "created": 1757046093,
      "owned_by": "Moonshot AI",
      "active": true,
      "context_window": 262144,
      "public_apps": null,
      "max_completion_tokens": 16384
    },
    {
      "id": "canopylabs/orpheus-v1-english",
      "object": "model",
      "created": 1766186316,
      "owned_by": "Canopy Labs",
      "active": true,
      "context_window": 4000,
      "public_apps": null,
      "max_completion_tokens": 50000
    },
    {
      "id": "meta-llama/llama-4-scout-17b-16e-instruct",
      "object": "model",
      "created": 1743874824,
      "owned_by": "Meta",
      "active": true,
      "context_window": 131072,
      "public_apps": null,
      "max_completion_tokens": 8192
    },
    {
      "id": "groq/compound-mini",
      "object": "model",
      "created": 1756949707,
      "owned_by": "Groq",
      "active": true,
      "context_window": 131072,
      "public_apps": null,
      "max_completion_tokens": 8192
    },
    {
      "id": "llama-3.3-70b-versatile",
      "object": "model",
      "created": 1733447754,
      "owned_by": "Meta",
      "active": true,
      "context_window": 131072,
      "public_apps": null,
      "max_completion_tokens": 32768
    },
    {
      "id": "whisper-large-v3-turbo",
      "object": "model",
      "created": 1728413088,
      "owned_by": "OpenAI",
      "active": true,
      "context_window": 448,
      "public_apps": null,
      "max_completion_tokens": 448
    },
    {
      "id": "whisper-large-v3",
      "object": "model",
      "created": 1693721698,
      "owned_by": "OpenAI",
      "active": true,
      "context_window": 448,
      "public_apps": null,
      "max_completion_tokens": 448
    },
    {
      "id": "llama-3.1-8b-instant",
      "object": "model",
      "created": 1693721698,
      "owned_by": "Meta",
      "active": true,
      "context_window": 131072,
      "public_apps": null,
      "max_completion_tokens": 131072
    },
    {
      "id": "meta-llama/llama-prompt-guard-2-86m",
      "object": "model",
      "created": 1748632165,
      "owned_by": "Meta",
      "active": true,
      "context_window": 512,
      "public_apps": null,
      "max_completion_tokens": 512
    }
  ]
}

```