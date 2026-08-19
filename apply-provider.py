#!/usr/bin/env python3
"""Merges one provider's env block into Claude Code settings.json WITHOUT
touching unrelated keys (permissions, enabledPlugins, etc.). Python twin of
apply-provider.ps1 - used by change-claude-code-provider.sh.

Conditional args (--model, --small-fast, --opus, --sonnet, --haiku,
--compact-window, --effort): set when non-empty, REMOVED when empty - so
switching away from a provider never leaks its stale model overrides.
"""
import argparse
import json
import os

parser = argparse.ArgumentParser()
parser.add_argument('--settings-file', required=True)
for name in ('api-key', 'base-url', 'auto-updates', 'model', 'small-fast',
             'opus', 'sonnet', 'haiku', 'compact-window', 'effort',
             'hook-command'):
    parser.add_argument('--' + name, default='')
args = parser.parse_args()

data = {}
if os.path.exists(args.settings_file):
    with open(args.settings_file, encoding='utf-8-sig') as f:
        data = json.load(f)

env = data.get('env', {})
env['ANTHROPIC_AUTH_TOKEN'] = args.api_key
env['ANTHROPIC_BASE_URL'] = args.base_url
env['API_TIMEOUT_MS'] = '3000000'
env['CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC'] = '1'
conditional = {
    'ANTHROPIC_MODEL': args.model,
    'ANTHROPIC_SMALL_FAST_MODEL': args.small_fast,
    'ANTHROPIC_DEFAULT_OPUS_MODEL': args.opus,
    'ANTHROPIC_DEFAULT_SONNET_MODEL': args.sonnet,
    'ANTHROPIC_DEFAULT_HAIKU_MODEL': args.haiku,
    'CLAUDE_CODE_AUTO_COMPACT_WINDOW': args.compact_window,
    'CLAUDE_CODE_EFFORT_LEVEL': args.effort,
}
for key, value in conditional.items():
    if value:
        env[key] = value
    else:
        env.pop(key, None)
data['env'] = env

if args.auto_updates:
    data['autoUpdatesChannel'] = args.auto_updates

# SessionStart hook: add ours for the local Qwen provider, keep any other
# hooks the user has; on remote providers remove only ours.
MARKER = 'claude-code-autostart'
hooks = data.get('hooks', {}) or {}
ss = [e for e in (hooks.get('SessionStart') or [])
      if MARKER not in json.dumps(e)]
if args.hook_command:
    ss.append({'hooks': [{'type': 'command',
                          'command': args.hook_command,
                          'timeout': 150}]})
if ss:
    hooks['SessionStart'] = ss
    data['hooks'] = hooks
elif 'hooks' in data:
    data['hooks'].pop('SessionStart', None)
    if not data['hooks']:
        del data['hooks']

with open(args.settings_file, 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)
    f.write('\n')
print('settings.json updated (merged, other keys preserved).')
