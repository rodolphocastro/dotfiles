winUserPath=$(wslpath "$(wslvar USERPROFILE)")

cp -r $winUserPath/.ssh ~
echo "Remember to chmod 600 each ssh key"
