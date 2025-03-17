clc
tic;

% 读取数据
test_file = 'dataform_testA2025.csv';
train_file = 'dataform_train2025.csv';

test_data_matrix = readmatrix(test_file);   
train_data_matrix = readmatrix(train_file);  

% 每两行为一组，第一行为输入T，第二行为输出V
% 温度固定为-20～69
temperture = -20:1:69;
voltage_train = train_data_matrix(2:2:end, :);  % [train_data_size, 90]
voltage_test = test_data_matrix(2:2:end, :);

train_data_size = size(voltage_train, 1);

% 参数设置
population_size = 200;
epochs = 100;
crossover_rate = 0.8;
variation_rate = 0.2;
elite_num = 5;   % 考虑保留一部分最优个体
record_cost = zeros(epochs, 1);

% 目标是找到最优的温度采样点，和对应的电压标定值，从而插值生成完整的电压标定曲线
% 布尔数组标记温度采样点，标准任务指定了三次样条插值，据此获得曲线计算适应度

% 生成初始种群
probability = 0.2; % 指定每个基因为1的概率
population = rand(population_size, length(temperture)) < probability; % [population_size, 90]
fitness = zeros(population_size, 1);

% 开始迭代
for i = 1:epochs

    % 生成population中每个解对应的插值曲线 [1000, train_data_size, 90]
    interpolation = zeros(population_size, train_data_size, length(temperture));
    for j = 1:population_size
        x = temperture(population(j,:) == 1); % 当前解对应的温度采样点
        for k = 1:train_data_size
            y_k = voltage_train(k, population(j,:) == 1); % 第k组数组的测定电压值 据此插值出90个点
            % 插值 方式是通过第k组电压值索引采样出对应的90个温度值 后续只需和标准的-20～69比对即可
            interpolation(j, k, :) = spline(y_k, x, voltage_train(k, :));
        %     plot(squeeze(interpolation(j, k, :)), voltage_train(k, :), 'r');
        %     hold on;
        %     plot(temperture, voltage_train(k, :), 'b');
        %     hold off;
        %     pause(10);
        end
    end

    % 计算适应度 [1000, 1]
    fitness = calculate_fitness(population, temperture, train_data_size, interpolation);
    % disp(fitness(1:5));

    % 记录每次迭代的最优适应度
    record_cost(i) = 1/max(fitness);
    % 打印每次迭代的最优适应度
    disp(['epoch: ', num2str(i), ' cost: ', num2str(record_cost(i))]);

    % 基于轮盘赌筛选个体
    [population, elite_population] = select_population(population, fitness, elite_num);

    % 交叉
    population = crossover(population, crossover_rate);

    % 变异
    population = variation(population, variation_rate);

    % 保留最优个体
    population(end-elite_num+1:end, :) = elite_population;
    % 记录最优个体的选择的点的索引
    disp(['当前最优解：', num2str(find(elite_population(1,:) == 1))]);

end
