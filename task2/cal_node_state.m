function state_node = cal_node_state(state_a, state_b)
    if state_a == 0 && state_b == 0
        state_node = 0;          %PF
    elseif (state_a == 0 && state_b == 2) || (state_a == 1 && state_b == 0) || (state_a == 1 && state_b == 2)
        state_node = 1;          %SO
    elseif (state_a == 2 && state_b == 0)
        state_node = 2;          %DM
    elseif (state_a == 0 && state_b == 1) || (state_a == 2 && state_b == 1)
        state_node = 3;          %MO
    elseif (state_a == 2 && state_b == 2) || (state_a == 3)
        state_node = 4;          %DN
    elseif state_a == 1 && state_b == 1
        state_node = 5;          %FB
    end
end