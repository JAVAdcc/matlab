function population = initialize_population(population_size, temperture_length, min_ones, max_ones)
    
    % 生成初始种群，1 的个数在固定范围内 [min_ones, max_ones]
    population = zeros(population_size, temperture_length); % 初始化种群

    for i = 1:population_size
        % 随机选择 1 的数量
        num_ones = randi([min_ones, max_ones]);
        % 随机选择 num_ones 个位置设置为 1
        indices = randperm(temperture_length, num_ones);
        population(i, indices) = 1;
    end

end