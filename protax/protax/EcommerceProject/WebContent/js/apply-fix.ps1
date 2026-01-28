# PowerShell script to apply fixes to main.js
# Run this script after closing the file in your editor

$filePath = "main.js"
$backupPath = "main.js.backup2"

Write-Host "Creating backup..." -ForegroundColor Yellow
Copy-Item $filePath $backupPath -Force

Write-Host "Reading file..." -ForegroundColor Yellow
$content = Get-Content $filePath -Raw

Write-Host "Applying fixes..." -ForegroundColor Yellow

# Fix 1: Add try-catch to initialization
$content = $content -replace '(?s)(// Initialize when DOM is ready\s+document\.addEventListener\(''DOMContentLoaded'', function\(\) \{\s+)(initNavbar\(\);)', '$1        try {`r`n            $2'
$content = $content -replace '(?s)(initCartAnimations\(\);\s+\}\);)', '$1        } catch (error) {`r`n            console.error(''Error initializing UI enhancements:'', error);`r`n        }`r`n    });'

# Fix 2: Add navigation link click handler
$initFix = @'

    // Ensure loading overlay doesn't block navigation
    window.addEventListener(''beforeunload'', function() {
        if (typeof hideLoading === ''function'') {
            hideLoading();
        }
    });
    
    // Ensure navigation links work properly - clear loading on click
    document.addEventListener(''click'', function(e) {
        const link = e.target.closest(''a'');
        if (link && link.href) {
            const href = link.getAttribute(''href'');
            if (href && !href.startsWith(''#'') && !href.startsWith(''javascript:'') && !href.startsWith(''mailto:'') && !href.startsWith(''tel:'')) {
                if (typeof hideLoading === ''function'') {
                    hideLoading();
                }
            }
        }
    }, false);

'@
$content = $content -replace '(?s)(    \}\);.*?// Navbar scroll effect)', "$1$initFix"

# Fix 3: Update form handler to skip AJAX forms
$content = $content -replace '(?s)(// Form submission with loading state\s+const forms = document\.querySelectorAll\(''form''\);)', '$1        const forms = document.querySelectorAll(''form:not([data-ajax="true"])'');'

# Fix 4: Fix hideLoading to remove all overlays
$content = $content -replace '(?s)(window\.hideLoading = function\(\) \{\s+const overlay = document\.getElementById\(''loading-overlay''\);\s+if \(overlay\) overlay\.remove\(\);\s+\};)', 'window.hideLoading = function() {`r`n            const overlays = document.querySelectorAll(''#loading-overlay'');`r`n            overlays.forEach(overlay => overlay.remove());`r`n        };'

# Fix 5: Update showLoading to remove existing overlays first
$content = $content -replace '(?s)(window\.showLoading = function\(\) \{\s+const overlay = document\.createElement\(''div''\);)', 'window.showLoading = function() {`r`n            const existing = document.getElementById(''loading-overlay'');`r`n            if (existing) existing.remove();`r`n            `r`n            const overlay = document.createElement(''div'');'

# Fix 6: Fix search auto-submit to only work on search forms
$searchFix = @'
    // Search with debounce - only for actual search forms
    let searchTimeout;
    const searchForms = document.querySelectorAll(''form[action*="search"], form[action*="Search"]'');
    searchForms.forEach(form => {
        const searchInput = form.querySelector(''input[name="q"], input[type="search"]'');
        if (searchInput && form.action && form.action.includes(''search'')) {
            let isUserTyping = false;
            searchInput.addEventListener(''focus'', function() {
                isUserTyping = true;
            });
            searchInput.addEventListener(''blur'', function() {
                isUserTyping = false;
                clearTimeout(searchTimeout);
            });
            searchInput.addEventListener(''input'', function() {
                if (!isUserTyping) return;
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    if (isUserTyping && this.value.length >= 3) {
                        form.submit();
                    }
                }, 800);
            });
        }
    });
'@
$content = $content -replace '(?s)(// Search with debounce.*?console\.log\(''✨ Protax Store UI Enhanced)', "$searchFix`r`n`r`n    $1"

Write-Host "Writing fixed file..." -ForegroundColor Yellow
Set-Content $filePath -Value $content -Force

Write-Host "Done! Fixes applied successfully." -ForegroundColor Green
Write-Host "Backup saved as: $backupPath" -ForegroundColor Cyan
