$errors = 0

function Assert-FileExists([string]$path, [string]$label) {
    if (Test-Path $path) {
        Write-Host "  PASS  $label" -ForegroundColor Green
    } else {
        Write-Host "  FAIL  $label -- not found: $path" -ForegroundColor Red
        $script:errors++
    }
}

function Assert-FileContains([string]$path, [string]$pattern, [string]$label) {
    if (-not (Test-Path $path)) {
        Write-Host "  FAIL  $label -- file missing: $path" -ForegroundColor Red
        $script:errors++
        return
    }
    $content = Get-Content $path -Raw
    if ($content -match $pattern) {
        Write-Host "  PASS  $label" -ForegroundColor Green
    } else {
        Write-Host "  FAIL  $label -- pattern not found in $path" -ForegroundColor Red
        $script:errors++
    }
}

Write-Host "`nTesting public/ output...`n"

# RSS feed
Assert-FileExists   "public\feeds\posts\default"   "RSS feed exists at feeds/posts/default"
Assert-FileContains "public\feeds\posts\default"   'rss'              "RSS feed is valid XML"
Assert-FileContains "public\feeds\posts\default"   'item'             "RSS feed contains at least one post"

# Sitemap
Assert-FileExists   "public\sitemap.xml"            "Sitemap exists"
Assert-FileContains "public\sitemap.xml"            'urlset|sitemap'   "Sitemap is valid XML"

# Homepage
Assert-FileExists   "public\index.html"             "Homepage (index.html) exists"

# Posts
$postCount = (Get-ChildItem "public" -Recurse -Filter "index.html" -ErrorAction SilentlyContinue).Count
if ($postCount -gt 10) {
    Write-Host "  PASS  Post pages exist ($postCount index.html files found)" -ForegroundColor Green
} else {
    Write-Host "  FAIL  Too few post pages (found $postCount, expected more than 10)" -ForegroundColor Red
    $errors++
}

Write-Host ""
if ($errors -eq 0) {
    Write-Host "All tests passed." -ForegroundColor Green
} else {
    Write-Host "$errors test(s) failed." -ForegroundColor Red
    exit 1
}
