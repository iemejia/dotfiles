#!/usr/bin/env bash
# Launch GitHub Copilot CLI against a local llama-server instance.
# Usage: copilot-local.sh [copilot args...]

export COPILOT_PROVIDER_BASE_URL=http://127.0.0.1:8080/v1
export COPILOT_PROVIDER_TYPE=openai
export COPILOT_MODEL=qwen3-coder-30b-a3b
export COPILOT_PROVIDER_MAX_PROMPT_TOKENS=49152
export COPILOT_PROVIDER_MAX_OUTPUT_TOKENS=16384

exec copilot "$@"
