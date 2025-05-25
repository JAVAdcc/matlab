% 计算系统可用性A
clear;

% 参数设置
t = 25000;
k = 4;
A = zeros(20, 1);

lambda_A = 1/(3.15e4);
p_A0 = exp(-lambda_A*t);
p_A1 = 0.25*(1-p_A0);
p_A2 = 0.35*(1-p_A0);
p_A3 = 0.4*(1-p_A0);

lambda_B = 1/(2.1e5);
p_B0 = exp(-lambda_B*t);
p_B1 = 0.45*(1-p_B0);
p_B2 = 0.55*(1-p_B0);

p_PF = p_A0*p_B0;
p_MO = p_A0*p_B1 + p_A2*p_B1;
p_SO = p_A0*p_B2 + p_A1*p_B0 + p_A1*p_B2;
p_FB = p_A1*p_B1;
p_DM = p_A2*p_B0;
p_DN = p_A2*p_B2 + p_A3*(p_B0+p_B1+p_B2);

p = [p_PF, p_MO, p_SO, p_FB, p_DM, p_DN];

for n = 4:20
    A_n = 0;
    
    partitions = zeros(nchoosek(n+6-1, 6-1), 6);
    idx = 1;
    
    % 生成所有可能的状态分布
    for i1 = 0:n
        for i2 = 0:n-i1
            for i3 = 0:n-i1-i2
                for i4 = 0:n-i1-i2-i3
                    for i5 = 0:n-i1-i2-i3-i4
                        i6 = n-i1-i2-i3-i4-i5;
                        Q_PF = i1; Q_MO = i2; Q_SO = i3; Q_FB = i4; Q_DM = i5; Q_DN = i6;
                        
                        % 计算对应的概率
                        prob = multinomial_pdf([Q_PF, Q_MO, Q_SO, Q_FB, Q_DM, Q_DN], n, p);
                        
                        % 计算系统状态
                        C1 = (Q_FB >= 1);
                        C2 = (Q_MO >= 2);
                        C3 = ((Q_PF + Q_MO + Q_DM) == 0);
                        C4 = ((Q_PF + Q_SO + ((Q_MO + Q_DM) > 0)) < k);
                        C5 = (Q_FB == 0);
                        C6 = ((Q_MO == 1) && ((Q_PF + Q_SO) >= k - 1));
                        C7 = (((Q_MO == 0) && (Q_PF >= 1) && (Q_PF + Q_SO >= k)) || ...
                              ((Q_MO == 0) && (Q_PF == 0) && (Q_DM >= 1) && (Q_SO >= k - 1)));
                        C8 = ((Q_FB + Q_MO) == 0);
                        C9 = ((Q_PF >= 1) && ((Q_PF + Q_SO) == k - 1) && (Q_DM >= 1));
                        
                        % 确定系统状态
                        if C1 || C2 || C3 || C4
                            % 状态1: 系统无效
                        elseif C5 && (C6 || C7)
                            % 状态2: 系统有效
                            A_n = A_n + prob;
                        elseif C8 && C9
                            % 状态3/4: 概率性判断
                            Pr = Q_DM / (Q_DM + Q_PF);
                            A_n = A_n + prob * Pr; % 直接用概率加权
                        end
                    end
                end
            end
        end
    end
    
    A(n) = A_n;
    fprintf('n = %d, A= %f\n', n, A(n));
end

function prob = multinomial_pdf(x, n, p)
    
    if sum(x) ~= n
        prob = 0;
        return;
    end
    
    coef = factorial(n);
    for i = 1:length(x)
        coef = coef / factorial(x(i));
    end
    
    prob = coef;
    for i = 1:length(x)
        prob = prob * p(i)^x(i);
    end
end
