
## API

OpenAI Respones API:
```http
POST https://api.openai.com/v1/responses
Authorization: Bearer $OPENAI_API_KEY
Content-Type: application/json
{
    "model": "gpt6.1-astra",
    "instructions": "xxx",
    "input": "yyy",
    "reasoning": "high",
    "stream": false
}
```

Oepnai TTS & STT & Audio Translations API:

```http
POST https://api.openai.com/v1/audio/speech
POST https://api.openai.com/v1/audio/transcriptions
POST https://api.openai.com/v1/audio/translations
```

Openai Embeddings API:

Openai Realtime API: (WebSocket)

```websocket
wss://api.openai.com/v1/realtime?model=gpt-realtime-2.1
```

Openai Decisions API:

```http
POST https://api.openai.com/v1/decisions
Authorization: Bearer $OPENAI_API_KEY
Content-Type: application/json
{
  "model": "gpt-6-luna",
  "input": "Package arrived damaged.",
  "questions": [
    {
      "type": "choice",
      "name": "category",
      "instructions": "Classify the issue.",
      "choices": [
        {"value": "shipping"},
        {"value": "product"},
        {"value": "other"}
      ]
    },
    {
      "type": "predicate",
      "name": "damaged",
      "instructions": "Is the product damaged?"
    },
    {
      "type": "score",
      "name": "severity",
      "instructions": "Rate severity.",
      "levels": [
        {"value": "low"},
        {"value": "medium"},
        {"value": "high"}
      ]
    }
  ]
}
```

## REPL (Read, Evaluate, Print, Loop)

## Token Tracing 

Token 巨量消耗的可能原因：
* `system_prompt`
* `history`
* `tool_schema`
* `tool_result`
* `rag_context`
* `usr_input`

在一个流程中，应该遵循 Progressive Disclosure 原则，越底层的数据越不应该立刻读取，
而应该关心当前的状态变化和下一步决策。

