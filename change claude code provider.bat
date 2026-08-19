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

set "PROVIDERS=zai47 zai5 zai51 zai52 zai52_300k zai53 zai53_300k minimax kimi nanogpt qwenfast qwensmart"

set "LABEL_zai47=ZAI (GLM4.7)"
set "APIKEYVAR_zai47=ZAI_API_KEY"
set "BASEURL_zai47=https://api.z.ai/api/anthropic"
set "AUTOUPDATES_zai47=latest"
set "MODEL_zai47=GLM-4.7"
set "SMALLFAST_zai47=GLM-4.7"
set "OPUS_zai47=GLM-4.7"
set "SONNET_zai47=GLM-4.7"
set "HAIKU_zai47=GLM-4.7"
set "EFFORT_zai47=xhigh"

set "LABEL_zai5=ZAI (GLM5)"
set "APIKEYVAR_zai5=ZAI_API_KEY"
set "BASEURL_zai5=https://api.z.ai/api/anthropic"
set "AUTOUPDATES_zai5=latest"
set "MODEL_zai5=GLM-5"
set "SMALLFAST_zai5=GLM-5"
set "OPUS_zai5=GLM-5"
set "SONNET_zai5=GLM-5"
set "HAIKU_zai5=GLM-5"
set "EFFORT_zai5=xhigh"

set "LABEL_zai51=ZAI (GLM5.1)"
set "APIKEYVAR_zai51=ZAI_API_KEY"
set "BASEURL_zai51=https://api.z.ai/api/anthropic"
set "AUTOUPDATES_zai51=latest"
set "MODEL_zai51=glm-5.1"
set "SMALLFAST_zai51=glm-5.1"
set "OPUS_zai51=glm-5.1"
set "SONNET_zai51=glm-5.1"
set "HAIKU_zai51=glm-5.1"
set "EFFORT_zai51=xhigh"

set "LABEL_zai52=ZAI (GLM5.2)"
set "APIKEYVAR_zai52=ZAI_API_KEY"
set "BASEURL_zai52=https://api.z.ai/api/anthropic"
set "AUTOUPDATES_zai52=latest"
set "MODEL_zai52="
set "SMALLFAST_zai52="
set "OPUS_zai52=glm-5.2[1m]"
set "SONNET_zai52=glm-5.2[1m]"
set "HAIKU_zai52=glm-4.5-air"
set "COMPACTWINDOW_zai52=1000000"
set "EFFORT_zai52=xhigh"

set "LABEL_zai52_300k=ZAI (GLM5.2 - 300k)"
set "APIKEYVAR_zai52_300k=ZAI_API_KEY"
set "BASEURL_zai52_300k=https://api.z.ai/api/anthropic"
set "AUTOUPDATES_zai52_300k=latest"
set "MODEL_zai52_300k="
set "SMALLFAST_zai52_300k="
set "OPUS_zai52_300k=glm-5.2[1m]"
set "SONNET_zai52_300k=glm-5.2[1m]"
set "HAIKU_zai52_300k=glm-4.5-air"
set "COMPACTWINDOW_zai52_300k=300000"
set "EFFORT_zai52_300k=xhigh"

set "LABEL_zai53=ZAI (GLM5.3)"
set "APIKEYVAR_zai53=ZAI_API_KEY"
set "BASEURL_zai53=https://api.z.ai/api/anthropic"
set "AUTOUPDATES_zai53=latest"
set "MODEL_zai53="
set "SMALLFAST_zai53="
set "OPUS_zai53=glm-5.3[1m]"
set "SONNET_zai53=glm-5.3[1m]"
set "HAIKU_zai53=glm-4.5-air"
set "COMPACTWINDOW_zai53=1000000"
set "EFFORT_zai53=xhigh"

set "LABEL_zai53_300k=ZAI (GLM5.3 - 300k)"
set "APIKEYVAR_zai53_300k=ZAI_API_KEY"
set "BASEURL_zai53_300k=https://api.z.ai/api/anthropic"
set "AUTOUPDATES_zai53_300k=latest"
set "MODEL_zai53_300k="
set "SMALLFAST_zai53_300k="
set "OPUS_zai53_300k=glm-5.3[1m]"
set "SONNET_zai53_300k=glm-5.3[1m]"
set "HAIKU_zai53_300k=glm-4.5-air"
set "COMPACTWINDOW_zai53_300k=300000"
set "EFFORT_zai53_300k=xhigh"

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

rem --- Local Qwen3.8 (llama-server, Anthropic-compatible /v1/messages on :8181) ---
rem Selecting one starts the model automatically; selecting any remote provider
rem stops it (frees GPU/RAM/CPU). Port 8181 because Docker takes 8080.
set "QWEN_BAT=C:\Users\trevo\Documents\qwen3.8 27b\claude-code-server.bat"
set "QWEN_AUTO=C:\Users\trevo\Documents\qwen3.8 27b\claude-code-autostart.bat"

set "LABEL_qwenfast=Local Qwen3.8 FAST (quick answers)"
set "APIKEYVAR_qwenfast=LOCAL_API_KEY"
set "BASEURL_qwenfast=http://127.0.0.1:8181"
set "AUTOUPDATES_qwenfast=latest"
set "MODEL_qwenfast=qwen3.8-fast"
set "SMALLFAST_qwenfast=qwen3.8-fast"
set "OPUS_qwenfast=qwen3.8-fast"
set "SONNET_qwenfast=qwen3.8-fast"
set "HAIKU_qwenfast=qwen3.8-fast"
set "COMPACTWINDOW_qwenfast=24000"

set "LABEL_qwensmart=Local Qwen3.8 SMART (best answers)"
set "APIKEYVAR_qwensmart=LOCAL_API_KEY"
set "BASEURL_qwensmart=http://127.0.0.1:8181"
set "AUTOUPDATES_qwensmart=latest"
set "MODEL_qwensmart=qwen3.8-smart"
set "SMALLFAST_qwensmart=qwen3.8-smart"
set "OPUS_qwensmart=qwen3.8-smart"
set "SONNET_qwensmart=qwen3.8-smart"
set "HAIKU_qwensmart=qwen3.8-smart"
set "COMPACTWINDOW_qwensmart=24000"

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
    set "HAS_MAPPING=0"
    if defined MODEL_%%P (
        set "HAS_MAPPING=1"
        echo     ANTHROPIC_MODEL: !MODEL_%%P!
    )
    if defined SMALLFAST_%%P (
        set "HAS_MAPPING=1"
        echo     ANTHROPIC_SMALL_FAST_MODEL: !SMALLFAST_%%P!
    )
    if defined OPUS_%%P (
        set "HAS_MAPPING=1"
        echo     ANTHROPIC_DEFAULT_OPUS_MODEL: !OPUS_%%P!
    )
    if defined SONNET_%%P (
        set "HAS_MAPPING=1"
        echo     ANTHROPIC_DEFAULT_SONNET_MODEL: !SONNET_%%P!
    )
    if defined HAIKU_%%P (
        set "HAS_MAPPING=1"
        echo     ANTHROPIC_DEFAULT_HAIKU_MODEL: !HAIKU_%%P!
    )
    if defined COMPACTWINDOW_%%P (
        set "HAS_MAPPING=1"
        echo     CLAUDE_CODE_AUTO_COMPACT_WINDOW: !COMPACTWINDOW_%%P!
    )
    if defined EFFORT_%%P (
        set "HAS_MAPPING=1"
        echo     CLAUDE_CODE_EFFORT_LEVEL: !EFFORT_%%P!
    )
    if "!HAS_MAPPING!"=="0" echo     Uses provider defaults
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
set "SELECTED_COMPACTWINDOW=!COMPACTWINDOW_%SELECTED%!"
set "SELECTED_EFFORT=!EFFORT_%SELECTED%!"

call :get_env_value "%SELECTED_APIKEYVAR%" SELECTED_APIKEY

rem --- Local model lifecycle ------------------------------------------------
rem Local provider picked -> start the tier and wait until it answers.
rem Remote provider picked -> stop the model so it stops hogging GPU/RAM/CPU.
echo !SELECTED! | findstr /b "qwen" >nul
if errorlevel 1 goto QWEN_STOP

set "QWEN_TIER=fast"
if "!SELECTED!"=="qwensmart" set "QWEN_TIER=smart"
rem Remember the tier + arm the SessionStart hook (auto-start after a reboot).
<nul set /p "=%QWEN_TIER%">"%USERPROFILE%\.claude\qwen-tier.txt" 2>nul
set "SELECTED_HOOKCOMMAND=%QWEN_AUTO%"
if not exist "%QWEN_BAT%" (
    echo ERROR: missing "%QWEN_BAT%" - cannot start the local model.
    goto QWEN_DONE
)
echo Starting local Qwen3.8 !QWEN_TIER! tier - loads in ~35-60 sec...
start "Qwen3.8 !QWEN_TIER!" /min cmd /c ""%QWEN_BAT%" !QWEN_TIER!"
set /a QWEN_TRIES=0
:QWEN_POLL
curl -s -m 2 http://127.0.0.1:8181/health 2>nul | findstr /C:"\"ok\"" >nul
if not errorlevel 1 goto QWEN_READY
set /a QWEN_TRIES+=1
if !QWEN_TRIES! GEQ 90 goto QWEN_TIMEOUT
timeout /t 2 /nobreak >nul
goto QWEN_POLL
:QWEN_READY
echo Local model is up on http://127.0.0.1:8181
goto QWEN_DONE
:QWEN_TIMEOUT
echo WARNING: model not ready after ~3 min - check the minimized Qwen3.8 window.
goto QWEN_DONE

:QWEN_STOP
taskkill /F /IM llama-server.exe >nul 2>&1
if not errorlevel 1 echo Local model stopped - GPU, RAM and CPU freed.
:QWEN_DONE
rem ---------------------------------------------------------------------------

rem --- Merge provider env into settings.json -------------------------------
rem Old version overwrote the WHOLE file, which stripped permissions,
rem enabledPlugins and friends - breaking every other running session.
rem apply-provider.ps1 merges the env block (and our SessionStart hook)
rem while preserving all other keys, and removes stale keys from the
rem previously selected provider.
if exist "%SETTINGS_FILE%" copy /y "%SETTINGS_FILE%" "%CLAUDE_DIR%\settings.json.switch-backup" >nul
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0apply-provider.ps1" ^
 -SettingsFile "%SETTINGS_FILE%" ^
 -ApiKey "!SELECTED_APIKEY!" ^
 -BaseUrl "!SELECTED_BASEURL!" ^
 -AutoUpdates "!SELECTED_AUTOUPDATES!" ^
 -Model "!SELECTED_MODEL!" ^
 -SmallFast "!SELECTED_SMALLFAST!" ^
 -Opus "!SELECTED_OPUS!" ^
 -Sonnet "!SELECTED_SONNET!" ^
 -Haiku "!SELECTED_HAIKU!" ^
 -CompactWindow "!SELECTED_COMPACTWINDOW!" ^
 -Effort "!SELECTED_EFFORT!" ^
 -HookCommand "!SELECTED_HOOKCOMMAND!"
if errorlevel 1 (
    echo ERROR: could not update settings.json - prior copy saved as settings.json.switch-backup
    goto :END
)

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