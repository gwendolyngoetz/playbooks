write-host "Importing Registry Settings"
reg import .\RegistrySettings\AquaSnapSettings.reg
reg import .\RegistrySettings\CleanupExplorerContextMenus.reg
reg import .\RegistrySettings\CmdAutoRunAlias.reg
reg import .\RegistrySettings\SaveChrome.reg
reg import .\RegistrySettings\SetDriveIcons.reg


write-host "Adding Open With Registry Settings"
new-item 'HKCU:\Software\Classes\*\shell\GVim'
new-item 'HKCU:\Software\Classes\*\shell\GVim\command'
new-item 'HKCU:\Software\Classes\*\shell\Notepad'
new-item 'HKCU:\Software\Classes\*\shell\Notepad\command'

# strings
'HKCU:\Software\Classes\*\shell\GVim\(default)'            'Open with GVim'
'HKCU:\Software\Classes\*\shell\GVim\Icon'                 '%userprofile%\settings\icons\vim.ico'
'HKCU:\Software\Classes\*\shell\GVim\command\(default)'    '$env:userprofile\vim\vim80\gvim.exe "%1"'
'HKCU:\Software\Classes\*\shell\Notepad\(default)'         'Open with Notepad'
'HKCU:\Software\Classes\*\shell\Notepad\command\(default)' 'c:\windows\system32\notepad.exe "%1"'

write-host "Setting variables"
$srcDir="d:\src"
$settingsDir="$env:userprofile\settings"
$iconsDir="$settingsDir\icons"

write-host "Adding custom environment variables"
setx src $srcDir
setx home $env:userprofile
setx ConEmuPromptNames NO

write-host "Creating Directories"
$srcDir
$settingsDir
$iconsDir
"$env:userprofile\.vim" 
"$env:userprofile\.tmp"

write-host "Copy Files"
cp .\alias.cmd $env:userprofile\alias.cmd
cp .\icons\* $env:userprofile\settings\icons
cp .\ConEmu\ConEmu.xml $env:appdata
