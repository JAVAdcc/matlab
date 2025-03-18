function [fitness, cost] = calculate_fitness(population, temperture, train_data_size, interpolation)
    % 计算适应度
    % population: [1000, 90]
    % temperture: [90, ]
    % interpolation: [1000, train_data_size, 90]
    % fitness: [1000, 1]
    population_size = size(population, 1);
    fitness = zeros(population_size, 1);
    cost = zeros(population_size, 1);
    Q = 60;  % 题目规定的单个点测定成本
    for i = 1:population_size
        % 计算每个解的适应度
        % 包含两部分 其一是population_i的测定成本，其二是插值的误差
        Q_i_cost = Q * sum(population(i, :));  % 测定成本
        % disp('Q_i_cost:');
        % disp(Q_i_cost);
        error_cost = 0;
        for j = 1:train_data_size
            error = abs(squeeze(interpolation(i, j, :)).' - squeeze(temperture));  % 误差
            % disp(size(error));
            % disp(size(temperture));
            % 画出error和temperture的关系图
            % scatter(temperture, squeeze(error), 'r');
            % hold on;
            % scatter(temperture, zeros(size(temperture)), 'b');
            % hold off;
            % pause(2);
            error_cost = error_cost + single_error_cost(error);
        end
        cost(i) = error_cost/train_data_size + Q_i_cost;
        % disp('error_cost:');
        % disp(error_cost);
        fitness(i) = 100 / (cost(i) - 240);
        if fitness(i) < 0
            fitness(i) = 0;
        end
    end
end

function cost = single_error_cost(error)
    % 计算单个插值误差的成本
    cost = 0;
    for i = 1:length(error)
        if error(i) <= 0.4
            cost = cost + 0;
        elseif error(i) <= 0.8
            cost = cost + 2;
        elseif error(i) <= 1.2
            cost = cost + 15;
        elseif error(i) <= 2.0
            cost = cost + 40;
        else
            cost = cost + 100000;
        end
    end
end