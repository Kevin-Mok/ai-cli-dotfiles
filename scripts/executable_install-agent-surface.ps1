[CmdletBinding()]
param(
    [switch]$DryRun,
    [switch]$InstallChezmoi,
    [switch]$Help,
    [switch]$ElevatedRelaunch
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $false

$script:InstalledChezmoiPath = $null
$script:InstalledChezmoiBinDir = $null
$script:ChezmoiConfigPath = $null
$script:TemporaryChezmoiConfigPath = $null

function Show-Usage {
    @'
Usage:
  .\scripts\executable_install-agent-surface.ps1 [-DryRun] [-InstallChezmoi]

What this does:
  - Treats this repo as the chezmoi source directory
  - Ensures chezmoi is available on Windows
  - Runs chezmoi apply globally from this repo
  - Uses `chezmoi -S <repo> apply -n -v` for dry runs
  - Uses `chezmoi -S <repo> apply` for real applies

Options:
  -DryRun            Preview the global apply without changing home-directory files.
  -InstallChezmoi    Install chezmoi if it is missing before running apply.
  -Help              Show this help text.

Environment:
  CHEZMOI_INSTALL_BIN_DIR  Override the directory used for optional chezmoi installation.
'@ | Write-Host
}

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "== $Message =="
}

function Write-Note {
    param([string]$Message)
    Write-Host $Message
}

function Test-IsAdministrator {
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal]::new($identity)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Ensure-ElevatedForApply {
    if ($DryRun -or $Help -or $ElevatedRelaunch) {
        return
    }

    if (Test-IsAdministrator) {
        Write-Note "Running with administrative rights."
        return
    }

    Write-Step "Requesting elevation"
    Write-Note "Global chezmoi apply needs elevated rights on this Windows machine for managed symlink targets."
    Write-Note "Triggering a UAC prompt and relaunching this script as administrator."

    $argumentList = @(
        '-NoProfile',
        '-File',
        "`"$PSCommandPath`"",
        '-ElevatedRelaunch'
    )
    if ($InstallChezmoi) {
        $argumentList += '-InstallChezmoi'
    }

    try {
        $process = Start-Process -FilePath 'powershell.exe' -ArgumentList $argumentList -Verb RunAs -Wait -PassThru
    } catch {
        Fail "UAC elevation was canceled or could not be started. Rerun the script from an elevated PowerShell window."
    }

    if ($process.ExitCode -ne 0) {
        exit $process.ExitCode
    }

    exit 0
}

function Fail {
    param(
        [string]$Message,
        [int]$ExitCode = 1
    )
    Write-Error $Message
    exit $ExitCode
}

function Resolve-AbsolutePath {
    param([string]$Path)

    if (Test-Path -LiteralPath $Path) {
        return [System.IO.Path]::GetFullPath((Resolve-Path -LiteralPath $Path).Path)
    }

    return [System.IO.Path]::GetFullPath($Path)
}

function Get-DefaultChezmoiBinDir {
    if ($env:CHEZMOI_INSTALL_BIN_DIR) {
        return Resolve-AbsolutePath -Path $env:CHEZMOI_INSTALL_BIN_DIR
    }

    return Join-Path $HOME '.local\bin'
}

function Get-ChezmoiCommand {
    $command = Get-Command chezmoi -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($command) {
        return $command.Source
    }

    $candidateBinDir = Get-DefaultChezmoiBinDir
    foreach ($candidate in @(
        (Join-Path $candidateBinDir 'chezmoi.exe'),
        (Join-Path $candidateBinDir 'chezmoi')
    )) {
        if (Test-Path -LiteralPath $candidate) {
            return $candidate
        }
    }

    if ($script:InstalledChezmoiPath -and (Test-Path -LiteralPath $script:InstalledChezmoiPath)) {
        return $script:InstalledChezmoiPath
    }

    return $null
}

function Install-Chezmoi {
    $installUrl = 'https://get.chezmoi.io/ps1'
    $binDir = Get-DefaultChezmoiBinDir

    if ($DryRun) {
        Write-Note "Would install chezmoi from $installUrl into $binDir"
        return
    }

    Write-Step "Installing chezmoi"
    Write-Note "chezmoi is not on PATH. Installing it to $binDir"
    New-Item -ItemType Directory -Force -Path $binDir | Out-Null

    $installScript = Invoke-RestMethod -Uri $installUrl
    $scriptBlock = [ScriptBlock]::Create($installScript)
    & $scriptBlock -b $binDir

    $candidate = Join-Path $binDir 'chezmoi.exe'
    if (-not (Test-Path -LiteralPath $candidate)) {
        $candidate = Join-Path $binDir 'chezmoi'
    }

    if (-not (Test-Path -LiteralPath $candidate)) {
        Fail "chezmoi installation completed, but no chezmoi binary was found in $binDir"
    }

    $script:InstalledChezmoiPath = $candidate
    $script:InstalledChezmoiBinDir = $binDir

    if (-not (($env:PATH -split ';') -contains $binDir)) {
        $env:PATH = "$binDir;$env:PATH"
    }

    if (-not (Get-ChezmoiCommand)) {
        Fail "chezmoi installation completed, but chezmoi is still not callable in the current session"
    }

    Write-Note "Installed chezmoi at $candidate"
}

function Ensure-Chezmoi {
    $existing = Get-ChezmoiCommand
    if ($existing) {
        Write-Note "Using chezmoi at $existing"
        return $existing
    }

    if (-not $InstallChezmoi) {
        Fail "chezmoi is required for this global apply flow. Install it first or rerun with -InstallChezmoi."
    }

    Install-Chezmoi

    if ($DryRun) {
        Write-Note "Continuing dry-run after the requested chezmoi install preview."
    }

    $existing = Get-ChezmoiCommand
    if (-not $existing) {
        Fail "chezmoi should be installed now, but it is still not callable"
    }

    return $existing
}

function Ensure-ChezmoiConfig {
    param(
        [string]$ChezmoiCommand,
        [string]$RepoRoot
    )

    $configPath = & $ChezmoiCommand execute-template '{{ .chezmoi.configFile }}'
    if (-not $configPath) {
        Fail "Unable to determine chezmoi config file path."
    }

    $configPath = $configPath.Trim()
    $script:ChezmoiConfigPath = $configPath
    if (Test-Path -LiteralPath $configPath) {
        Write-Note "Using existing chezmoi config at $configPath"
        return
    }

    $templatePath = Join-Path $RepoRoot 'dot_config\chezmoi\chezmoi-template.toml.tmpl'
    if (-not (Test-Path -LiteralPath $templatePath)) {
        Fail "Missing chezmoi config template at $templatePath"
    }

    $rendered = & $ChezmoiCommand execute-template --file $templatePath

    if ($DryRun) {
        $tempConfigDir = Join-Path ([System.IO.Path]::GetTempPath()) 'chezmoi-bootstrap'
        if (-not (Test-Path -LiteralPath $tempConfigDir)) {
            New-Item -ItemType Directory -Force -Path $tempConfigDir | Out-Null
        }
        $script:TemporaryChezmoiConfigPath = Join-Path $tempConfigDir 'chezmoi.toml'
        Set-Content -LiteralPath $script:TemporaryChezmoiConfigPath -Value $rendered
        Write-Note "Would render chezmoi config template to $configPath"
        Write-Note "Using temporary chezmoi config for this dry-run: $script:TemporaryChezmoiConfigPath"
        return
    }

    Write-Step "Bootstrapping chezmoi config"
    Write-Note "Rendering $templatePath to $configPath"
    $configDir = Split-Path -Parent $configPath
    if ($configDir -and -not (Test-Path -LiteralPath $configDir)) {
        New-Item -ItemType Directory -Force -Path $configDir | Out-Null
    }

    Set-Content -LiteralPath $configPath -Value $rendered
    Write-Note "Wrote chezmoi config to $configPath"
}

if ($Help) {
    Show-Usage
    exit 0
}

$repoRoot = Resolve-AbsolutePath -Path (Join-Path $PSScriptRoot '..')
if (-not (Test-Path -LiteralPath (Join-Path $repoRoot '.git'))) {
    Fail "The script expects to run from a checked-out git repo, but .git was not found under $repoRoot"
}

Ensure-ElevatedForApply

$chezmoiCommand = Ensure-Chezmoi
Ensure-ChezmoiConfig -ChezmoiCommand $chezmoiCommand -RepoRoot $repoRoot

$chezmoiArgs = @()
if ($script:TemporaryChezmoiConfigPath) {
    $chezmoiArgs += @('--config', $script:TemporaryChezmoiConfigPath)
}
$chezmoiArgs += @('-S', $repoRoot, 'apply')
if ($DryRun) {
    $chezmoiArgs += @('-n', '-v')
}

Write-Step "Applying tracked source state globally"
Write-Note "Repo source: $repoRoot"
Write-Note "Dry run: $($DryRun.IsPresent)"
Write-Note "Command:"
Write-Note "  $chezmoiCommand $($chezmoiArgs -join ' ')"

$previousExitCode = $LASTEXITCODE
$chezmoiOutput = & $chezmoiCommand @chezmoiArgs 2>&1
$chezmoiExitCode = $LASTEXITCODE
if ($chezmoiOutput) {
    $chezmoiOutput | ForEach-Object { Write-Host $_ }
}

if ($chezmoiExitCode -ne 0) {
    $outputText = ($chezmoiOutput | Out-String)
    if ($outputText -match 'A required privilege is not held by the client') {
        if (Test-IsAdministrator) {
            Fail "chezmoi apply still failed on symlink creation even after elevation. Enable Windows Developer Mode or grant symlink privileges, then rerun the script."
        }

        Fail "chezmoi apply failed because Windows denied symlink creation. Rerun the script and accept the UAC elevation prompt."
    }

    Fail "chezmoi apply failed with exit code $chezmoiExitCode."
}

$global:LASTEXITCODE = $previousExitCode

Write-Step "Summary"
if ($DryRun) {
    Write-Note "Dry-run completed for the global chezmoi apply from this repo."
} else {
    Write-Note "Global chezmoi apply completed from this repo."
}

if ($script:InstalledChezmoiBinDir) {
    Write-Note "chezmoi was installed into $script:InstalledChezmoiBinDir for this session."
    Write-Note "Add that directory to your persistent PATH if you want the chezmoi command available in new shells."
}
