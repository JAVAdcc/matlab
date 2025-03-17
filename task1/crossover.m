function population = crossover(population, crossover_rate)
    % 交叉
    % population: [1000, 90]
    % crossover_rate: 0.8
    population_size = size(population, 1);
    for i = 1:2:population_size
        if rand(1) < crossover_rate
            % 随机选择交叉点
            cross_point = randi([1, 90], 1);
            % 交叉
            population([i, i+1], cross_point:end) = population([i, i+1], cross_point:end);
        end
    end
end