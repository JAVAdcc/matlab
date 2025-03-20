function population = crossover(population, crossover_rate)
    % 交叉
    % population: [1000, 90]
    % crossover_rate: 0.8
    population_size = size(population, 1);
    for i = 1:2:population_size
        if rand(1) < crossover_rate
            % 随机选择两个交叉点
            cross_point1 = randi([1, 44], 1);
            cross_point2 = randi([45, 90], 1);
            % 交叉
            population([i+1, i], cross_point1:cross_point2) = population([i, i+1], cross_point1:cross_point2);
        end
    end
end