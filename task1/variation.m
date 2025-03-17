function population = variation(population, variation_rate)
    % 变异
    % population: [1000, 90]
    % variation_rate: 0.1
    for i = 1:size(population, 1)
        if rand(1) < variation_rate
            % 随机选择变异点
            variation_point = randi([1, 90], 1);
            % 变异
            population(i, variation_point) = 1 - population(i, variation_point);
        end
    end
end