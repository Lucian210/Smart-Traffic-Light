@echo off
set xv_path=D:\\AC\\Vivado\\2016.4\\bin
call %xv_path%/xsim Semafor_behav -key {Behavioral:sim_1:Functional:Semafor} -tclbatch Semafor.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
