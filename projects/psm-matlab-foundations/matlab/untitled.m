N=8;
n=0:(16*N-1);
x=2*sin(2*pi*n/N+pi/2)
%tamanho da amostra
n_x=length(x);

M=2;
%primeiro fazer um vetor com o comprimento que preciso, mas vazio, 
% para dps preencher com o loop
y=zeros(1,n_x)
%preencher o vetor vazio
for i=1:n_x;
    %como n existe x(o) e aplicando a formula o x(i-1) vai dar x(0) ( que
    %como n existe é 0, tenho q fzr o if, pq se i==1:
    %y(i)=1/2*x(i)(nao entra na soma o x(i-1)
    if i==1:
    y(i)=1/2*x(i)
    else
        y(i)=1/2*(x(i)+x(i-1));
    end
end

