function [n_zeros] = ElementosNulosFuncao(vetor)
%a funcao determina o numero de zeros
%  presentes num vetor
%[n_zeros]=ElementosNulosFuncao(vetor)

n_zeros=0;
for i=1:length(vetor)
    if vetor(i) == 0
        n_zeros=n_zeros + 1;
    end
end
end