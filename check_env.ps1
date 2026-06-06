Write-Host "============================================"
Write-Host "  GIS QuanZhan KaiFa HuanJing - BanBen ZiJian"
Write-Host "============================================"
Write-Host ""

$pass = 0
$fail = 0

$checks = @(
    @{Name="Node.js"; Cmd="node --version"; Optional=$false},
    @{Name="pnpm"; Cmd="pnpm --version"; Optional=$false},
    @{Name="Python"; Cmd="python --version"; Optional=$false},
    @{Name="Java"; Cmd="java -version 2>&1"; Optional=$false},
    @{Name="Git"; Cmd="git --version"; Optional=$false},
    @{Name="Docker"; Cmd="docker --version"; Optional=$true}
)

foreach ($c in $checks) {
    try {
        $ver = Invoke-Expression $c.Cmd -ErrorAction Stop
        Write-Host ("  [OK] " + $c.Name + " " + $ver) -ForegroundColor Green
        $pass++
    } catch {
        if ($c.Optional) {
            Write-Host ("  [--] " + $c.Name + " not found (optional)") -ForegroundColor Yellow
        } else {
            Write-Host ("  [!!] " + $c.Name + " not found") -ForegroundColor Red
            $fail++
        }
    }
}

Write-Host ""
Write-Host "============================================"
if ($fail -eq 0) {
    Write-Host ("  Result: " + $pass + " all passed") -ForegroundColor Green
} else {
    Write-Host ("  Result: " + $pass + " passed, " + $fail + " failed") -ForegroundColor Yellow
}
Write-Host "============================================"
Write-Host ""
if ($fail -gt 0) {
    Write-Host "  Please install tools marked [!!]" -ForegroundColor Yellow
    Write-Host ""
}
Read-Host "Press Enter to exit"
