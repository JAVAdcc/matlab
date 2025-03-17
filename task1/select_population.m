function [new_population, elite_population] = select_population(population, fitness, elite_num)

    new_population = zeros(size(population));

    % 找出精英个体
    [~, index] = sort(fitness, 'descend');
    elite_population = population(index(1:elite_num), :);

    % 归一化适应度 用轮盘赌选择
    nomalized_fitness = fitness / sum(fitness);
    for i = 1:length(population)
        cumulate_prob = 0;
        rand_limit = rand(1);
        for j = 1:length(population)
            cumulate_prob = cumulate_prob + nomalized_fitness(j);
            if cumulate_prob >= rand_limit
                new_population(i, :) = population(j, :);
                break;
            end
        end
    end
end