@echo off
set xv_path=D:\\AC\\Vivado\\2016.4\\bin
call %xv_path%/xelab  -wto 8570971a54334e69bcd52bbd38ff6d93 -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot Semafor_behav xil_defaultlib.Semafor -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
