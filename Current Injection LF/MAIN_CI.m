%Author:Arun Suresh
%Date: 05/27/2019
% Distribution System Load Flow using Current Injection Based Method
%%
%Please consider citing following paper(s) if the code was useful for your research

% A. Suresh, K. Murari and S. Kamalasadan, "Injected Current Sensitivity Based Load Flow Algorithm for Multi-Phase Distribution
% System in the Presence of Distributed Energy Resources," in IEEE Transactions on Power Delivery, vol. 37, no. 6, pp. 5081-5093,
% Dec. 2022, doi: 10.1109/TPWRD.2022.3167621.

% A. Suresh, S. Kamalasadan and S. Paudyal, "A Novel Three-Phase Transmission and Unbalance Distribution Co-Simulation Power Flow 
% Model For Long Term Voltage Stability Margin Assessment," 2021 IEEE Power & Energy Society General Meeting (PESGM), Washington
% DC, USA, 2021, pp. 1-5, doi: 10.1109/PESGM46819.2021.9638047.
%%
clear;clc
    pb=waitbar(0,'Select Test System');pause(.5)
System=SystemSelect();% Select Test System from the repository
    waitbar(0.20,pb,'Loading Network Data');pause(.5)
System=ImportSystemData(System);% Import System data to create Ybus and perform Load flow
    waitbar(0.40,pb,'Building Y bus');pause(.5)
System=BuildYbus(System);% Create Bus Admittance Matrix Ybus
    waitbar(0.60,pb,'Performing Load Flow');pause(.5)
System=PerformLoadFlow(System);% Perform Current Injection Based Load Flow
    waitbar(0.90,pb,'Generating Report');pause(.5)
    writeLFResults=1;writeYbus=0;% 1-will write to report, 0-will not write to report (writing Ybus for larger systems are time consuming)
System=GenerateReport(System,writeLFResults,writeYbus);% Generate and Store Results with Time stamps in a folder 
    waitbar(0.95,pb,'Plotting Voltage');pause(.5)
% PlotVoltage % Plot Voltages
CompareVoltage % Compare Voltages with respect to a Benchmark
    close(pb)