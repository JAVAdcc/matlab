tic;
clc;
clear;

Nsamlples = 100000;
w = 25000;      %给定参数
R = zeros(1, 17);       %可靠度
MTTF = zeros(1, 17);  %平均首次失效时间
Tf = 220000;      % 系统最大运行时间

for n = 4:20    % n：节点数
    [R[n-3], MTTF[n-3]]
end

[R_max, R_max_I]= max(R);
[MTTF_max, MTTF_max_I] = max(MTTF);
fprintf('当节点数为%d时，有最大系统可靠性R(ω)=%f\n', R_max_I+3, R_max);
fprintf('当节点数为%d时，有最长平均首次失效时间MTTF=%fhours\n', MTTF_max_I+3, MTTF_max);

toc;