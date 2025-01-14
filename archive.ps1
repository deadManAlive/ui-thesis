Write-Host "Archiving..."

$archiveFolder = ".\archives"

if (-not (Test-Path -Path $archiveFolder)) {
    New-Item -ItemType Directory -Path $archiveFolder | Out-Null
}

&git archive --output=./archives/skripsi-editable.zip --format=zip HEAD ":!present*" ":!paper*" ":!charged-ieee"

Push-Location fray
&git archive --output=../archives/fray.zip --format=zip HEAD
Pop-Location

Push-Location archives
&7z x fray.zip -ofray | Out-Null
&7z a skripsi-editable.zip fray | Out-Null
Remove-Item -Recurse fray*
Pop-Location

&git archive --output=./archives/jurnal-editable.zip --format=zip HEAD ./chapters ./paper paper.typ sources.bib ./charged-ieee README ":!chapters/ch*.typ"
&git archive --output=./archives/presentasi-editable.zip --format=zip HEAD ./chapters ./present present.typ config.typ sources.bib ./primer/assets/makara_color.png README ":!ch*.typ"

Write-Host "Done."