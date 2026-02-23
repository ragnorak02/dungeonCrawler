@echo off
REM Amaris headless test runner
REM Usage: run-tests.bat

set GODOT=Z:\godot\godot.exe
set PROJECT=Z:\Development\amatris\dungeonCrawler

echo [Amaris] Running tests...
"%GODOT%" --headless --path "%PROJECT%" --script res://tests/test_runner.gd
echo [Amaris] Tests complete. Results in tests/test_results.json
