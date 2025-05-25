tic;
clc;
clear;

Nsamlples = 100000;
w = 25000;      %给定参数
R = zeros(1, 17);       %可靠度
MTTF = zeros(1, 17);  %平均首次失效时间
time_limit = 220000;      % 系统最大运行时间

for n = 4:20    % n：节点数
    % 测试不同节点数下的情况
    [R(n-3), MTTF(n-3)] = test_node(n, Nsamlples, w, time_limit);
end

[R_max, R_max_I]= max(R);
[MTTF_max, MTTF_max_I] = max(MTTF);
fprintf('%d个节点时有最大R(ω)=%f\n', R_max_I+3, R_max);
fprintf('%d个节点时有最大MTTF=%f\n', MTTF_max_I+3, MTTF_max);

toc;