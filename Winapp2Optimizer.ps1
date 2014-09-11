#Requires -Version 2
$ErrorActionPreference = 'SilentlyContinue'
$path                  = "" + $(Get-Location) + "\Winapp2.ini"
$file                  = [IO.File]::ReadAllText($path).Split("[")
$fileKeys              = "[Winapp2*]","LangSecRef=3025","Default=True"
$regKeys               = @()
$excludeKeys           = @()
$a                     = 1
$b                     = 1
$c                     = 1
$tmp                   = [Environment]::OSVersion.Version
$os                    = [Version]("" + $tmp.Major + "." + $tmp.Minor)
ForEach ($item In $file) {
    $correctOs = "true"
    $detectOs  = $item | Select-String -Pattern "DetectOS.*=([^\r\n]*)" -AllMatches | Select -Expand Matches | ForEach {$_.groups[1].value}
    if ($detectOs -ne $null) {
        ForEach ($var In $detectOs) {
            if (($var.EndsWith("|") -and $os -lt ([Version]($var.Split("|")[0]))) -or ($var.StartsWith("|") -and $os -gt ([Version]($var.Split("|")[-1]))) -or (!$var.Contains("|") -and $os -ne ([Version]$var))) {
                $correctOs = "false"
                break
            }
        }
    }
    if ($correctOs -eq "true") {
        $checkedOne    = "false"
        $allowed       = "false"
        $specialDetect = $item | Select-String -Pattern "SpecialDetect.*=([^\r\n]*)" -AllMatches | Select -Expand Matches | ForEach {$_.groups[1].value}
        if ($specialDetect -ne $null) {
            ForEach ($var In $specialDetect) {
                $checkedOne = "true"
                $allowed    = "true"
                break
            }
        }
        if ($allowed -eq "false") {
            $detectFile = $item | Select-String -Pattern "DetectFile.*=([^\r\n]*)" -AllMatches | Select -Expand Matches | ForEach {$_.groups[1].value}
            if ($detectFile -ne $null) {
                ForEach ($var In $detectFile) {
                    $checkedOne = "true"
                    if (Test-Path ([Environment]::ExpandEnvironmentVariables($var.Replace("|", "\").Replace("%Documents%", "%UserProfile%\Documents"))).Replace("Program Files", "Program Files*")) {
                        $allowed = "true"
                        break
                    }
                }
            }
            if ($allowed -eq "false") {
                $detect = $item | Select-String -Pattern "Detect[^OF=]*=([^\r\n]*)" -AllMatches | Select -Expand Matches | ForEach {$_.groups[1].value}
                if ($detect -ne $null) {
                    ForEach ($var In $detect) {
                        $checkedOne = "true"
                        if (Test-Path $var.Replace("|", "\").Insert(4, ":")) {
                            $allowed = "true"
                            break
                        }
                    }
                }
            }
        }
        if ($allowed -eq $checkedOne) {
            $excludable = @()
            $fileKey    = $item | Select-String -Pattern "FileKey.*=([^\r\n]*)" -AllMatches | Select -Expand Matches | ForEach {$_.groups[1].value}
            if ($fileKey -ne $null) {
                ForEach ($var In $fileKey) {
                    $tmp = [Environment]::ExpandEnvironmentVariables($var.Split("|")[0].Replace("%Documents%", "%UserProfile%\Documents")).Replace("Program Files", "Program Files*")
                    if ($var.EndsWith("REMOVESELF", "CurrentCultureIgnoreCase")) {
                        if ($tmp.EndsWith("\", "CurrentCultureIgnoreCase")) {
                            $tmp.Remove($tmp.LastIndexOf("\"), 1)
                        }
                        $tmp = $tmp.Substring(0, $tmp.LastIndexOf("\"))
                    }
                    if (Test-Path $tmp) {
                        $excludable += $var.Split("|")[0]
                        $fileKeys   += "FileKey" + $a + "=" + $var
                        $a++
                    }
                }
            }
            $regKey = $item | Select-String -Pattern "RegKey.*=([^\r\n]*)" -AllMatches | Select -Expand Matches | ForEach {$_.groups[1].value}
            if ($regKey -ne $null) {
                ForEach ($var In $regKey) {
                    $tmp = $var.Insert(4, ":")
                    if ($tmp.Contains("|")) {
                        $tmp = $tmp.Split("|")[0]
                    }
                    else {
                        if ($tmp.EndsWith("\", "CurrentCultureIgnoreCase")) {
                            $tmp.Remove($tmp.LastIndexOf("\"), 1)
                        }
                        $tmp = $tmp.Substring(0, $tmp.LastIndexOf("\"))
                    }
                    if (Test-Path $tmp) {
                        $excludable += $var.Split("|")[0]
                        $regKeys    += "RegKey" + $b + "=" + $var
                        $b++
                    }
                    else {

                    }
                }
            }
            $excludeKey = $item | Select-String -Pattern "ExcludeKey.*=([^\r\n]*)" -AllMatches | Select -Expand Matches | ForEach {$_.groups[1].value}
            if ($excludeKey -ne $null) {
                ForEach ($var In $excludeKey) {
                    $ok = "false"
                    ForEach ($ex In $excludable) {
                        if ($var.Contains($ex)) {
                            $ok = "true"
                            break
                        }
                    }
                    if ($ok -eq "true") {
                        $excludeKeys += "ExcludeKey" + $c + "=" + $var
                        $c++
                    }
                }
            }
        }
    }
}
$fileKeys + $regKeys + $excludeKeys | Out-File $path
