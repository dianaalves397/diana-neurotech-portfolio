function num_zeros = contar_zeros(v)
%%esta funçao conta os zeros num vetor de input
%%num_zeros = contar_zeros(v)

    num_zeros = 0;

    for i = 1:length(v)

        if v(i) == 0
            num_zeros = num_zeros + 1;
        end

    end

end