@echo off
set "SCRIPT_DIR=%~dp0"
set "GH_API_URL=https://api.github.com/repos/Ryujinx/release-channel-master/releases/latest"
set "RYU_REGEX=^^test-ava-ryujinx-.*-win_x64.zip$"
set "RYU_EXE_PATH=%SCRIPT_DIR%publish\Ryujinx.exe"

powershell -ExecutionPolicy Bypass -Command "$latest_release = Invoke-RestMethod -Uri '%GH_API_URL%'; $asset = $latest_release.assets | Where-Object { $_.name -match '%RYU_REGEX%' }; if ($asset) { $asset_url = $asset.browser_download_url; $file_name = $asset.name; $file_path = Join-Path '%SCRIPT_DIR%' $file_name; if (!((Test-Path -Path '%RYU_EXE_PATH%') -and ([System.Version][System.Diagnostics.FileVersionInfo]::GetVersionInfo('%RYU_EXE_PATH%').FileVersion -ge [System.Version]$latest_release.tag_name))) { Invoke-WebRequest -Uri $asset_url -OutFile $file_path; Expand-Archive -Path $file_path -DestinationPath '%SCRIPT_DIR%' -Force } }"

start "" /B "%RYU_EXE_PATH%" %*
