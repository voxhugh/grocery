# 配置入口
[[ $- != *i* ]] && return

CFG="$HOME/.cfg"
for m in env alias func git; do
    [[ -f "$CFG/$m" ]] && . "$CFG/$m"
done
