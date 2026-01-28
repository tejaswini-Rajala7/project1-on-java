Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Product Image URL Updater" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This will update all product image URLs in the database"
Write-Host "to use local uploads instead of placeholder URLs."
Write-Host ""
Write-Host "Press any key to continue..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Set-Location $PSScriptRoot

Write-Host ""
Write-Host "Compiling project..." -ForegroundColor Yellow
& mvn compile
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Compilation failed! Please check for errors above." -ForegroundColor Red
    pause
    exit $LASTEXITCODE
}

Write-Host ""
Write-Host "Running Image URL Updater..." -ForegroundColor Yellow
& mvn exec:java

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Update Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Please restart your server and clear browser cache."
Write-Host ""
pause
