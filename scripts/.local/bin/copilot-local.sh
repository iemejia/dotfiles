#!/usr/bin/env bash
# Launch GitHub Copilot CLI against a local mlx_lm.server instance.
# Usage: copilot-local.sh [copilot args...]

export COPILOT_PROVIDER_BASE_URL=http://127.0.0.1:8080/v1
export COPILOT_PROVIDER_TYPE=openai
export COPILOT_MODEL=mlx-community/Qwen3-Coder-30B-A3B-Instruct-4bit

exec copilot "$@"
