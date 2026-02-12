@echo off
setlocal enabledelayedexpansion

set CLAUDE_DIR=C:\Users\trevo\.claude
set SETTINGS_FILE=%CLAUDE_DIR%\settings.json
set ENV_FILE=%~dp0.env

if not exist "%ENV_FILE%" (
    echo Missing .env file at: %ENV_FILE%
    echo Create it from .env.example first.
    goto :END
)

set "PROVIDERS=zai47 zai5 minimax kimi nanogpt"

set "LABEL_zai47=ZAI (GLM4.7)"
set "APIKEYVAR_zai47=ZAI_API_KEY"
set "BASEURL_zai47=https://api.z.ai/api/anthropic"
set "AUTOUPDATES_zai47=latest"
set "MODEL_zai47=GLM-4.7"
set "SMALLFAST_zai47=GLM-4.7"
set "OPUS_zai47=GLM-4.7"
set "SONNET_zai47=GLM-4.7"
set "HAIKU_zai47=GLM-4.7"

set "LABEL_zai5=ZAI (GLM5)"
set "APIKEYVAR_zai5=ZAI_API_KEY"
set "BASEURL_zai5=https://api.z.ai/api/anthropic"
set "AUTOUPDATES_zai5=latest"
set "MODEL_zai5=GLM-5"
set "SMALLFAST_zai5=GLM-5"
set "OPUS_zai5=GLM-5"
set "SONNET_zai5=GLM-5"
set "HAIKU_zai5=GLM-5"

set "LABEL_minimax=MiniMax (2.5)"
set "APIKEYVAR_minimax=MINIMAX_API_KEY"
set "BASEURL_minimax=https://api.minimax.io/anthropic"
set "AUTOUPDATES_minimax=latest"
set "MODEL_minimax=MiniMax-M2.5"
set "SMALLFAST_minimax=MiniMax-M2.5"
set "OPUS_minimax=MiniMax-M2.5"
set "SONNET_minimax=MiniMax-M2.5"
set "HAIKU_minimax=MiniMax-M2.5"

set "LABEL_kimi=kimi.com (Kimi K2.5)"
set "APIKEYVAR_kimi=KIMI_API_KEY"
set "BASEURL_kimi=https://api.kimi.com/coding/"
set "AUTOUPDATES_kimi=latest"
set "MODEL_kimi="
set "SMALLFAST_kimi="
set "OPUS_kimi="
set "SONNET_kimi="
set "HAIKU_kimi="

set "LABEL_nanogpt=NanoGPT"
set "APIKEYVAR_nanogpt=NANOGPT_API_KEY"
set "BASEURL_nanogpt=https://nano-gpt.com/api/v1"
set "AUTOUPDATES_nanogpt=latest"
set "MODEL_nanogpt=moonshotai/kimi-k2.5"
set "SMALLFAST_nanogpt=moonshotai/kimi-k2.5"
set "OPUS_nanogpt=moonshotai/kimi-k2.5"
set "SONNET_nanogpt=moonshotai/kimi-k2.5"
set "HAIKU_nanogpt=moonshotai/kimi-k2.5"

echo Claude Code Commands:
echo   /opus   - Switch to Opus model
echo   /sonnet - Switch to Sonnet model
echo   /haiku  - Switch to Haiku model
echo.
echo   To check the current model: /model
echo.

echo Available Providers:
set /a idx=0
for %%P in (%PROVIDERS%) do (
    set /a idx+=1
    set "PICK_!idx!=%%P"
    echo !idx! - !LABEL_%%P!
)
echo.
echo Current model mappings:
for %%P in (%PROVIDERS%) do (
    echo   !LABEL_%%P!:
    if defined MODEL_%%P (
        echo     ANTHROPIC_MODEL: !MODEL_%%P!
        echo     ANTHROPIC_SMALL_FAST_MODEL: !SMALLFAST_%%P!
        echo     ANTHROPIC_DEFAULT_OPUS_MODEL: !OPUS_%%P!
        echo     ANTHROPIC_DEFAULT_SONNET_MODEL: !SONNET_%%P!
        echo     ANTHROPIC_DEFAULT_HAIKU_MODEL: !HAIKU_%%P!
    ) else (
        echo     Uses provider defaults
    )
)
echo.

echo Choose the provider to use:
set /a menuIndex=0
for %%P in (%PROVIDERS%) do (
    set /a menuIndex+=1
    set "MENU_!menuIndex!=%%P"
    echo !menuIndex! - !LABEL_%%P!
)
set /p CHOICE="Enter 1 to !menuIndex!: "

call set "SELECTED=%%MENU_%CHOICE%%%"
if not defined SELECTED (
    echo.
    echo Invalid choice. Please run again and enter a valid option.
    goto :END
)

set "SELECTED_LABEL=!LABEL_%SELECTED%!"
set "SELECTED_APIKEYVAR=!APIKEYVAR_%SELECTED%!"
set "SELECTED_BASEURL=!BASEURL_%SELECTED%!"
set "SELECTED_AUTOUPDATES=!AUTOUPDATES_%SELECTED%!"
set "SELECTED_MODEL=!MODEL_%SELECTED%!"
set "SELECTED_SMALLFAST=!SMALLFAST_%SELECTED%!"
set "SELECTED_OPUS=!OPUS_%SELECTED%!"
set "SELECTED_SONNET=!SONNET_%SELECTED%!"
set "SELECTED_HAIKU=!HAIKU_%SELECTED%!"

call :get_env_value "%SELECTED_APIKEYVAR%" SELECTED_APIKEY

> "%SETTINGS_FILE%" echo {
if defined SELECTED_AUTOUPDATES >> "%SETTINGS_FILE%" echo   "autoUpdatesChannel": "%SELECTED_AUTOUPDATES%",
>> "%SETTINGS_FILE%" echo   "env": {
>> "%SETTINGS_FILE%" echo     "ANTHROPIC_AUTH_TOKEN": "%SELECTED_APIKEY%",
>> "%SETTINGS_FILE%" echo     "ANTHROPIC_BASE_URL": "%SELECTED_BASEURL%",
>> "%SETTINGS_FILE%" echo     "API_TIMEOUT_MS": "3000000",
>> "%SETTINGS_FILE%" echo     "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": 1
if defined SELECTED_MODEL >> "%SETTINGS_FILE%" echo     ,"ANTHROPIC_MODEL": "%SELECTED_MODEL%"
if defined SELECTED_SMALLFAST >> "%SETTINGS_FILE%" echo     ,"ANTHROPIC_SMALL_FAST_MODEL": "%SELECTED_SMALLFAST%"
if defined SELECTED_OPUS >> "%SETTINGS_FILE%" echo     ,"ANTHROPIC_DEFAULT_OPUS_MODEL": "%SELECTED_OPUS%"
if defined SELECTED_SONNET >> "%SETTINGS_FILE%" echo     ,"ANTHROPIC_DEFAULT_SONNET_MODEL": "%SELECTED_SONNET%"
if defined SELECTED_HAIKU >> "%SETTINGS_FILE%" echo     ,"ANTHROPIC_DEFAULT_HAIKU_MODEL": "%SELECTED_HAIKU%"
>> "%SETTINGS_FILE%" echo   }
>> "%SETTINGS_FILE%" echo }

echo.
echo Switched to %SELECTED_LABEL% settings.

:END
endlocal
exit /b

:get_env_value
setlocal
set "search=%~1="
set "value="
for /f "usebackq tokens=1* delims==" %%A in (`findstr /b /c:"%search%" "%ENV_FILE%"`) do (
    set "value=%%B"
    goto :get_env_value_done
)
:get_env_value_done
endlocal & set "%~2=%value%"
exit /b