function state_sys = cal_sys_state(state_node)
    k = 4;
    
    Q_PF = sum(state_node(:) == 0);
    Q_SO = sum(state_node(:) == 1);
    Q_DM = sum(state_node(:) == 2);
    Q_MO = sum(state_node(:) == 3);
    Q_DN = sum(state_node(:) == 4);
    Q_FB = sum(state_node(:) == 5);

    C1 = (Q_FB >= 1);
    C2 = (Q_MO >= 2);
    C3 = ((Q_PF + Q_MO + Q_DM) == 0);
    C4 = ((Q_PF + Q_SO + ((Q_MO + Q_DM) > 0)) < k);
    C5 = (Q_FB == 0);
    C6 = ((Q_MO == 1) && ((Q_PF + Q_SO) >= k - 1));
    C7 = (((Q_MO == 0) && (Q_PF >= 1) && (Q_PF + Q_SO >= k)) || ((Q_MO == 0) && (Q_PF == 0) && (Q_DM >= 1) && (Q_SO >= k - 1)));
    C8 = ((Q_FB + Q_MO) == 0);
    C9 = ((Q_PF >= 1) && ((Q_PF + Q_SO) == k - 1) && (Q_DM >= 1));

    if C1 || C2 || C3 || C4
        state_sys = 1;
    elseif C5 && (C6 || C7)
        state_sys = 2;
    elseif C8 && C9
        Pr = Q_DM / (Q_DM + Q_PF);
        if rand < Pr
            state_sys = 3;
        else
            state_sys = 4;
        end
    end
end