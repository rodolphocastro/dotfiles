$codeExtensions = code --list-extensions
$codeExtensions | ForEach-Object -Process { &code --install-extension $_ --force }