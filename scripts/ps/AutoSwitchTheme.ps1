# 注册表路径
$reg="HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize"
# 日出日落
$light=[DateTime]::Parse("07:00")
$dark=[DateTime]::Parse("18:00")
$now=Get-Date
# 根据时间确定主题值
$theme=if($now -ge $light -and $now -lt $dark){1}else{0}
# 更新注册表主题设置
&{param($n,$v)if((Get-ItemProperty -Path $reg -Name $n -EA SilentlyContinue).$n -ne $v){New-ItemProperty -Path $reg -Name $n -Value $v -Type Dword -Force | Out-Null}} -n "SystemUsesLightTheme" -v $theme
&{param($n,$v)if((Get-ItemProperty -Path $reg -Name $n -EA SilentlyContinue).$n -ne $v){New-ItemProperty -Path $reg -Name $n -Value $v -Type Dword -Force | Out-Null}} -n "AppsUseLightTheme" -v $theme
# 重启资源管理器（建议手动刷新）
# Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
# Start-Process -FilePath explorer.exe -ErrorAction SilentlyContinue