# Files to concatenate
$sources = @(
    "dv_config.mqh"
    "dv_version.mqh"
    "dv_logger.mqh"
    "dv_common.mqh"
    "dv_vector.mqh"
    "dv_map.mqh"
    "dv_class_vector.mqh"
    "dv_class_map.mqh"
    "dv_ui_manager.mqh"
    "dv_order_book.mqh"
)

$source_folder = ".\source"

# Clear previous
$output = "$PSScriptRoot\dv_tools.mqh"

if (Test-Path "$output")
{
    Write-Host "Previous version of dv_tools.mqh removed"
    Remove-Item $output
}

# Increment build in version header
$build_number = 0
$version_file = "$source_folder\dv_version.mqh"
$build_line_regex = "#define DV_BUILD \d+"

foreach($line in Get-Content $version_file)
{
    if($line -match $build_line_regex)
    {
        $build_number = [int]($line -replace "\D", "") + 1
        break
    }
}

(Get-Content $version_file) -replace $build_line_regex, "#define DV_BUILD $build_number" | Set-Content $version_file -Encoding UTF8

# Scan sources for start/end tags and appends them in a single file
$accept_lines = 0
foreach ( $source in $sources )
{
    Write-Host "Processing $source..."
    $filepath = "$source_folder\$source"

    $line_counter = 0
    $total_lines = 0

    foreach($line in Get-Content $filepath)
    {
        $total_lines++

        if($line -match "//@START@")
        {
            $accept_lines = 1
            Add-Content -Path $output -Value "///////////////////////////////////////////////////////////////////////////////`n// $source`n"
            continue;
        }
        elseif ($line -match "//@END@")
        {
            $accept_lines = 0
        }

        if($accept_lines)
        {
            Add-Content -Path $output -Value $line
            $line_counter++
        }
    }

    Write-Host "Added $line_counter/$total_lines lines from $source"

    if($accept_lines)
    {
        $accept_lines = 0
        Write-Host "Missing '//@END@' tag in $filepath"
    }
}

Write-Host "Completed merging of sources in $output"