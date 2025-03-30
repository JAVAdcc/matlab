clc
tic;

% 读取数据
test_file = 'dataform_testA2025.csv';
train_file = 'dataform_train2025.csv';

test_data_matrix = readmatrix(test_file);   
train_data_matrix = readmatrix(train_file);  

% 每两行为一组，第一行为输入T，第二行为输出V
% 温度固定为-20～69
temperture = -20:1:69;  % [1,90]

voltage_train = train_data_matrix(2:2:end, :);  % [train_data_size, 90]
voltage_test = test_data_matrix(2:2:end, :);

train_data_size = size(voltage_train, 1);

% 参数设置
population_size = 2000;
epochs = 150;
crossover_rate = 0.6;
variation_rate = 0.2;
variation_num = 1;
elite_num = 10;   % 考虑保留一部分最优个体
record_cost = zeros(epochs, 1);
min_ones = 4;
max_ones = 90;
best_choice_num = 90;

% 目标是找到最优的温度采样点，和对应的电压标定值，从而插值生成完整的电压标定曲线
% 布尔数组标记温度采样点，标准任务指定了三次样条插值，据此获得曲线计算适应度

population = initialize_population(population_size, length(temperture), min_ones, max_ones);

%init_best_solution_1 = zeros(1, length(temperture));
%init_best_solution_1([1, 12, 25, 48, 77, 88]) = 1;
%init_best_solution_2 = zeros(1, length(temperture));
%init_best_solution_2([3, 25, 35, 75, 87]) = 1;
%population(1, :) = init_best_solution_1;
%population(2, :) = init_best_solution_2;
% init_best_solution_3 = zeros(1, length(temperture));
% init_best_solution_3([3, 13, 25, 46, 76, 87]) = 1;
% population(3, :) = init_best_solution_3;

fitness = zeros(population_size, 1);
cost = zeros(population_size, 1);
minist_cost = 1000000;

% 记录连续多少次最优解没有变化 到达limit后把一定数量的种群重置
stop_step = 0;
stop_step_limit = 10;
change_population_num = population_size / 2;

% 开始迭代
for i = 1:epochs

    % 生成population中每个解对应的插值曲线 [1000, train_data_size, 90]
    interpolation = zeros(population_size, train_data_size, length(temperture));
    for j = 1:population_size
        x = temperture(population(j,:) == 1); % 当前解对应的温度采样点
        for k = 1:train_data_size
            y_k = voltage_train(k, population(j,:) == 1); % 第k组数组的测定电压值 据此插值出90个点
            % 插值 方式是通过第k组电压值索引采样出对应的90个温度值 后续只需和标准的-20～69比对即可
            interpolation(j, k, :) = interp1(y_k, x, voltage_train(k, :), 'spline');
            % scatter(x, y_k, 'r');
            % hold on;
            % plot(squeeze(interpolation(j, k, :)), voltage_train(k, :), 'r');
            % hold on;
            % plot(temperture, voltage_train(k, :), 'b');
            % hold off;
            % pause(10);
        end
    end

    % 计算适应度 [1000, 1]
    [fitness, cost] = calculate_fitness(population, temperture, train_data_size, interpolation);
    % disp(fitness(1:5));

    % 记录每次迭代的最小成本
    record_cost(i) = min(cost);
    % 打印每次迭代的最小成本    
    disp(['epoch: ', num2str(i), ' cost: ', num2str(record_cost(i))]);

    % 基于轮盘赌筛选个体
    [population, elite_population] = select_population(population, fitness, elite_num);

    % 交叉
    population = crossover(population, crossover_rate);

    % 变异
    population = variation(population, variation_rate, variation_num);

    % 保留最优个体
    if elite_num
        population(end-elite_num+1:end, :) = elite_population;
        % 记录最优个体的选择的点的索引
        best_choice = find(elite_population(1,:) == 1);
        disp(['当前最优解：', num2str(best_choice)]);
        [~, best_choice_num] = size(best_choice);
    end
    
    % 更新 stop_step
    if i > 1 && record_cost(i) >= minist_cost % 当前cost没有变得更小 
        stop_step = stop_step + 1;
    else
        stop_step = 0;
    end
    minist_cost = min(record_cost(i), minist_cost); % 更新最小成本

    % 到达 stop_step_limit 重置一部分种群
    if stop_step >= stop_step_limit
        stop_step = 0;
        disp(['重置一部分种群', '数目为：', num2str(change_population_num)]);
        % 生成不重复的随机索引
        random_indices = randperm(size(population, 1) - elite_num, change_population_num);
        population(random_indices, :) = initialize_population(change_population_num, length(temperture), best_choice_num-1, best_choice_num+1);
    end
end

figure;
% 打印成本变化
scatter(1:epochs, record_cost, 'r');
hold on;
plot(1:epochs, record_cost, 'b');
hold off;

figure;
% 打印最后一轮解空间形式
scatter(1:population_size, fitness, 'r');

toc;
