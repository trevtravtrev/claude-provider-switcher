#!/bin/bash

CLAUDE_DIR="$HOME/.claude"
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
ENV_FILE="$(dirname "$0")/.env"

PROVIDERS=("zai47" "zai5" "zai51" "minimax" "kimi" "nanogpt")

LABEL_zai47="ZAI (GLM4.7)"
API_KEY_VAR_zai47="ZAI_API_KEY"
BASE_URL_zai47="https://api.z.ai/api/anthropic"
AUTO_UPDATES_zai47="latest"
MODEL_zai47="GLM-4.7"
SMALL_FAST_MODEL_zai47="GLM-4.7"
OPUS_MODEL_zai47="GLM-4.7"
SONNET_MODEL_zai47="GLM-4.7"
HAIKU_MODEL_zai47="GLM-4.7"

LABEL_zai5="ZAI (GLM5)"
API_KEY_VAR_zai5="ZAI_API_KEY"
BASE_URL_zai5="https://api.z.ai/api/anthropic"
AUTO_UPDATES_zai5="latest"
MODEL_zai5="GLM-5"
SMALL_FAST_MODEL_zai5="GLM-5"
OPUS_MODEL_zai5="GLM-5"
SONNET_MODEL_zai5="GLM-5"
HAIKU_MODEL_zai5="GLM-5"

LABEL_zai51="ZAI (GLM5.1)"
API_KEY_VAR_zai51="ZAI_API_KEY"
BASE_URL_zai51="https://api.z.ai/api/anthropic"
AUTO_UPDATES_zai51="latest"
MODEL_zai51="glm-5.1"
SMALL_FAST_MODEL_zai51="glm-5.1"
OPUS_MODEL_zai51="glm-5.1"
SONNET_MODEL_zai51="glm-5.1"
HAIKU_MODEL_zai51="glm-5.1"

LABEL_minimax="MiniMax (2.5)"
API_KEY_VAR_minimax="MINIMAX_API_KEY"
BASE_URL_minimax="https://api.minimax.io/anthropic"
AUTO_UPDATES_minimax=""
MODEL_minimax="MiniMax-M2.5"
SMALL_FAST_MODEL_minimax="MiniMax-M2.5"
OPUS_MODEL_minimax="MiniMax-M2.5"
SONNET_MODEL_minimax="MiniMax-M2.5"
HAIKU_MODEL_minimax="MiniMax-M2.5"

LABEL_kimi="kimi.com (Kimi K2.5)"
API_KEY_VAR_kimi="KIMI_API_KEY"
BASE_URL_kimi="https://api.kimi.com/coding/"
AUTO_UPDATES_kimi=""
MODEL_kimi=""
SMALL_FAST_MODEL_kimi=""
OPUS_MODEL_kimi=""
SONNET_MODEL_kimi=""
HAIKU_MODEL_kimi=""

LABEL_nanogpt="NanoGPT"
API_KEY_VAR_nanogpt="NANOGPT_API_KEY"
BASE_URL_nanogpt="https://nano-gpt.com/api/v1"
AUTO_UPDATES_nanogpt=""
MODEL_nanogpt="moonshotai/kimi-k2.5"
SMALL_FAST_MODEL_nanogpt="moonshotai/kimi-k2.5"
OPUS_MODEL_nanogpt="moonshotai/kimi-k2.5"
SONNET_MODEL_nanogpt="moonshotai/kimi-k2.5"
HAIKU_MODEL_nanogpt="moonshotai/kimi-k2.5"

if [[ ! -f "$ENV_FILE" ]]; then
    echo "Missing .env file at: $ENV_FILE"
    echo "Create it from .env.example first."
    exit 1
fi

get_provider_field() {
    local provider="$1"
    local field="$2"
    local var_name="${field}_${provider}"
    printf '%s' "${!var_name}"
}

get_env_value() {
    local key="$1"
    local line
    line=$(grep -m1 "^${key}=" "$ENV_FILE" || true)
    printf '%s' "${line#*=}"
}

echo "Claude Code Commands:"
echo "  /opus   - Switch to Opus model"
echo "  /sonnet - Switch to Sonnet model"
echo "  /haiku  - Switch to Haiku model"
echo ""
echo "  To check the current model: /model"
echo ""

echo "Available Providers:"
choice=1
declare -a CHOICE_PROVIDERS
for provider in "${PROVIDERS[@]}"; do
    label=$(get_provider_field "$provider" "LABEL")
    echo "$choice - $label"
    CHOICE_PROVIDERS[$choice]="$provider"
    choice=$((choice + 1))
done

echo ""
echo "Current model mappings:"
for provider in "${PROVIDERS[@]}"; do
    label=$(get_provider_field "$provider" "LABEL")
    model=$(get_provider_field "$provider" "MODEL")
    small=$(get_provider_field "$provider" "SMALL_FAST_MODEL")
    opus=$(get_provider_field "$provider" "OPUS_MODEL")
    sonnet=$(get_provider_field "$provider" "SONNET_MODEL")
    haiku=$(get_provider_field "$provider" "HAIKU_MODEL")
    echo "  $label:"
    if [[ -n "$model" || -n "$small" || -n "$opus" || -n "$sonnet" || -n "$haiku" ]]; then
        [[ -n "$model" ]] && echo "    ANTHROPIC_MODEL: $model"
        [[ -n "$small" ]] && echo "    ANTHROPIC_SMALL_FAST_MODEL: $small"
        [[ -n "$opus" ]] && echo "    ANTHROPIC_DEFAULT_OPUS_MODEL: $opus"
        [[ -n "$sonnet" ]] && echo "    ANTHROPIC_DEFAULT_SONNET_MODEL: $sonnet"
        [[ -n "$haiku" ]] && echo "    ANTHROPIC_DEFAULT_HAIKU_MODEL: $haiku"
    else
        echo "    Uses provider defaults"
    fi
done

echo ""
echo "Choose the provider to use:"
for ((i=1; i<choice; i++)); do
    selected_provider="${CHOICE_PROVIDERS[$i]}"
    label=$(get_provider_field "$selected_provider" "LABEL")
    echo "$i - $label"
done
read -p "Enter 1 to $((choice - 1)): " CHOICE

SELECTED_PROVIDER="${CHOICE_PROVIDERS[$CHOICE]}"

if [[ -z "$SELECTED_PROVIDER" ]]; then
    echo ""
    echo "Invalid choice. Please run again and enter a valid option."
    exit 1
fi

selected_label=$(get_provider_field "$SELECTED_PROVIDER" "LABEL")
selected_api_key_var=$(get_provider_field "$SELECTED_PROVIDER" "API_KEY_VAR")
selected_api_key=$(get_env_value "$selected_api_key_var")
selected_base_url=$(get_provider_field "$SELECTED_PROVIDER" "BASE_URL")
selected_auto_updates=$(get_provider_field "$SELECTED_PROVIDER" "AUTO_UPDATES")
selected_model=$(get_provider_field "$SELECTED_PROVIDER" "MODEL")
selected_small=$(get_provider_field "$SELECTED_PROVIDER" "SMALL_FAST_MODEL")
selected_opus=$(get_provider_field "$SELECTED_PROVIDER" "OPUS_MODEL")
selected_sonnet=$(get_provider_field "$SELECTED_PROVIDER" "SONNET_MODEL")
selected_haiku=$(get_provider_field "$SELECTED_PROVIDER" "HAIKU_MODEL")

env_lines=(
"\"ANTHROPIC_AUTH_TOKEN\": \"$selected_api_key\""
"\"ANTHROPIC_BASE_URL\": \"$selected_base_url\""
"\"API_TIMEOUT_MS\": \"3000000\""
"\"CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC\": 1"
)

[[ -n "$selected_model" ]] && env_lines+=("\"ANTHROPIC_MODEL\": \"$selected_model\"")
[[ -n "$selected_small" ]] && env_lines+=("\"ANTHROPIC_SMALL_FAST_MODEL\": \"$selected_small\"")
[[ -n "$selected_opus" ]] && env_lines+=("\"ANTHROPIC_DEFAULT_OPUS_MODEL\": \"$selected_opus\"")
[[ -n "$selected_sonnet" ]] && env_lines+=("\"ANTHROPIC_DEFAULT_SONNET_MODEL\": \"$selected_sonnet\"")
[[ -n "$selected_haiku" ]] && env_lines+=("\"ANTHROPIC_DEFAULT_HAIKU_MODEL\": \"$selected_haiku\"")

{
    echo "{"
    if [[ -n "$selected_auto_updates" ]]; then
        echo "  \"autoUpdatesChannel\": \"$selected_auto_updates\"," 
    fi
    echo "  \"env\": {"
    for i in "${!env_lines[@]}"; do
        if [[ "$i" -lt "$((${#env_lines[@]} - 1))" ]]; then
            echo "    ${env_lines[$i]},"
        else
            echo "    ${env_lines[$i]}"
        fi
    done
    echo "  }"
    echo "}"
} > "$SETTINGS_FILE"

echo ""
echo "Switched to $selected_label settings."
