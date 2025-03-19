function population = variation(population, variation_rate, variation_num)
    % 变异
    % population: [1000, 90]
    for i = 1:size(population, 1)
        if rand(1) < variation_rate
            % 随机选择变异点
            variation_points = randi([1, 90], variation_num);
            % 变异
            population(i, variation_points) = 1 - population(i, variation_points);
        end
    end
end