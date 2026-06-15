@echo off
chcp 936 >nul
cls
echo ==============================================
echo 系统一键修复 - 恢复Windows默认设置
echo 请【以管理员身份】运行
echo ==============================================
echo.
echo 本脚本仅重置系统设置，不会删除任何文件和软件。
echo.
pause
cls

echo [1/8] 重置组策略...
RD /S /Q "%WinDir%\System32\GroupPolicy"
RD /S /Q "%WinDir%\System32\GroupPolicyUsers"
gpupdate /force >nul

echo [2/8] 恢复视觉效果、选择框、透明效果...
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /V VisualFXSetting /T REG_DWORD /D 0 /F >nul
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V ListviewAlphaSelect /T REG_DWORD /D 1 /F >nul
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /V ShowTranslucentSelection /T REG_DWORD /D 1 /F >nul
REG ADD "HKCU\Control Panel\Desktop\WindowMetrics" /V MinAnimate /T REG_DWORD /D 1 /F >nul

echo [3/8] 恢复CPU调度、进程优先级、系统响应...
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\PriorityControl" /V Win32PrioritySeparation /T REG_DWORD /D 2 /F >nul
REG ADD "HKLM\SYSTEM\CurrentControlSet\Control" /V SystemResponsiveness /T REG_DWORD /D 10 /F >nul

echo [4/8] 重置网络、DNS、Winsock...
netsh winsock reset >nul
netsh int ip reset >nul
ipconfig /flushdns >nul

echo [5/8] 重建图标缓存...
taskkill /f /im explorer.exe >nul 2>nul
del /f /s /q "%localappdata%\IconCache.db" >nul 2>nul
del /f /s /q "%localappdata%\Microsoft\Windows\Explorer\*" >nul 2>nul
start explorer.exe >nul

echo [6/8] 开始系统文件检查(SFC)...
sfc /scannow

echo [7/8] 修复系统映像(DISM)...
DISM /Online /Cleanup-Image /ScanHealth >nul
DISM /Online /Cleanup-Image /RestoreHealth

echo [8/8] 最终系统文件校验...
sfc /scannow

cls
echo ==============================================
echo 修复完成！
echo 所有系统设置已恢复为Windows默认。
echo 请重启电脑使设置完全生效。
echo ==============================================
echo.
pause
exit