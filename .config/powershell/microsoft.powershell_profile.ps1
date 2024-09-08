[console]::inputencoding = [console]::outputencoding = new-object system.text.utf8encoding

$profile_omp = "$psscriptroot/jirateep12_black.omp.json"
oh-my-posh init pwsh --config $profile_omp | invoke-expression

set-psreadlinekeyhandler -chord "ctrl+d" -function deletechar
set-psreadlinekeyhandler -chord "enter" -function validateandacceptline
set-psreadlineoption -editmode emacs -bellstyle none

set-psfzfoption -psreadlinechordprovider "ctrl+f" -psreadlinechordreversehistory "ctrl+r"

set-alias vim "nvim"
set-alias g "git"
set-alias lg "lazygit"
set-alias pip "pip3"
set-alias grep "findstr"
set-alias tig "$ENV:USERPROFILE\scoop\apps\git\current\usr\bin\tig.exe"
set-alias less "$ENV:USERPROFILE\scoop\apps\git\current\usr\bin\less.exe"

function ls() {
  eza -g --icons
}

function la() {
  eza -g --icons -a
}

function ll() {
  eza -l -g --icons
}

function lla() {
  eza -l -g --icons -a
}

function ide() {
  sh $ENV:USERPROFILE\appdata\local\script\ide.sh
}

function youtube_download() {
  sh $ENV:USERPROFILE\appdata\local\script\youtube_download.sh
}

function cleanup_directories() {
  sh $ENV:USERPROFILE\appdata\local\script\cleanup_directories.sh
}

function initialize_command_history() {
  sh $ENV:USERPROFILE\appdata\local\script\initialize_command_history.sh
}

function resize_dock() {
  sh $ENV:USERPROFILE\appdata\local\script\resize_dock.sh
}

function which ($command) {
  get-command -name $command -erroraction silentlycontinue | select-object -expandproperty definition -erroraction silentlycontinue
}

$sorted_history = $function:prompt

function prompt() {
  python3 "$ENV:USERPROFILE\AppData\Local\script\sorted_history.py"
  &$sorted_history
}
