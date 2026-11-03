#!/usr/bin/env bash
set -uo pipefail
[ -f .env ] || { echo ".env is missing"; exit 1; }
set -a; source .env; set +a

BASE="https://ai-platform.gisa.de"
AUTH="Authorization: Bearer ${GISA_API_KEY}"
CHAT="${GISA_CHAT_MODEL:-DeepSeek-V4-Flash-0731}"
EMB="${GISA_EMBEDDING_MODEL:-qwen3-embedding-4b}"

echo "== GET $BASE/models"
code=$(curl -s -o /tmp/gisa_models.json -w '%{http_code}' -H "$AUTH" "$BASE/models")
echo "HTTP $code"; [ "$code" = 200 ] && python3 -c 'import json;d=json.load(open("/tmp/gisa_models.json"));print([m.get("id") for m in d.get("data",[])])' \
  || echo "/models not available – Model-Allowlist (OPENAI_API_CONFIGS) is still in effect."

echo; echo "== POST $BASE/chat/completions ($CHAT)"
curl -s -H "$AUTH" -H "Content-Type: application/json" "$BASE/chat/completions" \
  -d "{\"model\":\"$CHAT\",\"messages\":[{\"role\":\"user\",\"content\":\"Only say: OK\"}],\"max_tokens\":20}" \
  | python3 -c 'import sys,json;d=json.load(sys.stdin);print("Answer:",d["choices"][0]["message"]["content"])' \
  || echo "Chat failed"

echo; echo "== POST $BASE/embeddings ($EMB)"
curl -s -H "$AUTH" -H "Content-Type: application/json" "$BASE/embeddings" \
  -d "{\"model\":\"$EMB\",\"input\":[\"Test eins\",\"Test zwei\"]}" \
  | python3 -c 'import sys,json;d=json.load(sys.stdin);v=d["data"];print("Dimensions:",len(v[0]["embedding"]))' \
  || echo "Embeddings failed (or Batch-Input not supported)"
echo; echo "Dimensions should be ${EMBEDDING_DIMENSIONS:-2560}."
