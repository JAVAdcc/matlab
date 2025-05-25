function [R, MTTF] = test_node(n, Nsamlples, w, Tf)
    syslife = zeros(1, Nsamlples);      % 系统寿命
    cnt = 0; %计算超过w的次数
    for i = 1:Nsamlples

        % 需要生成a、b器件发生故障的时间和故障类型
        lambda_a = 1/(3.15e4);
        lambda_b = 1/(2.1e5);
        a_life = exprnd(1/lambda_a, 1, n); 
        b_life = exprnd(1/lambda_b, 1, n);
        [life_order, index] = sort([a_life, b_life]); 
        % 这一步将获取所有故障时间的排序 不管是ab
        % 后续依次处理 用index在1-n还是n+1-2n判断哪个器件

        % 分别设置故障类型
        a_err_type = zeros(1, n);
        b_err_type = zeros(1, n);
        for j = 1:n
            rand_num = rand();
            if rand_num < 0.25
                a_err_type(j) = 1; 
            elseif rand_num < 0.6
                a_err_type(j) = 2;
            else
                a_err_type(j) = 3;
            end
        end
        for j = 1:n
            rand_num = rand();
            if rand_num < 0.45
                b_err_type(j) = 1; 
            else
                b_err_type(j) = 2;
            end
        end

        % 开始仿真 先初始化系统
        life = 0;
        state_node = zeros(1, n);  % 0表示正常
        state_a = zeros(1, n);    
        state_b = zeros(1, n);
        state_sys = 0; % 0表示正常

        for j = 1:2*n   %一共2n个故障
            life = life_order(j);
            err_index = index(j); % 出错的node
            if(err_index <= n)
                % 说明为a
                state_a(err_index) = a_err_type(err_index);
            else
                err_index = err_index - n;
                state_b(err_index) = b_err_type(err_index);
            end  
            % 先更新state_node
            state_node(err_index) = cal_node_state(state_a(err_index), state_b(err_index));
            % 再更新state_sys
            state_sys = cal_sys_state(state_node);
            if state_sys == 1 || state_sys == 4
                life = min(life, Tf); % 限制life的最值
                if life > w
                    cnt = cnt + 1; % 计算超过w的次数
                end
                syslife(i) = life; % 记录系统寿命
                break;  
                % 结束故障推进 防止复活
            end
        end

    end

    % 还需要修正syslife为0的情况 表示没有故障 应该设为Tf
    cnt = cnt + sum(syslife==0);  % 修正超过w的次数
    syslife(syslife == 0) = Tf;
    

    % 计算并返回
    R = cnt / Nsamlples; 
    MTTF = mean(syslife);

    fprintf('nodes：%d\n', n);
    fprintf('MTTF=%f\n', MTTF);
    fprintf('R(ω)=%f\n\n', R);

end