
N=8;
n=0:(16*N-1);
xn=2*sin(2*pi*n/N+pi/2);
nome='ECG';

vmax=max(xn);
vmin=min(xn);
vpp=vmax-vmin;
vmed=mean(xn);
vstd=std(xn);
energy=sum(xn.^2);
potencia=energy/length(xn);
autocorrelacao=xcorr(xn);

caracteristicas_sinal(xn,nome);

% FUNCAO
function caracteristicas_sinal(xn,nome)

vmax=max(xn);
vmin=min(xn);
vpp=vmax-vmin;
vmed=mean(xn);
vstd=std(xn);
energy=sum(xn.^2);
potencia=energy/length(xn);
[autocorrelacao,lags]=xcorr(xn);

fid1=fopen('parametros_do_sinal.csv','w');

if fid1==-1
    error('Houve erro na criacao do ficheiro')
end

fprintf(fid1,'Nome,Vmax,Vmin,Vpp,Vmed,DesvioPadrao,Energia,Potencia');

for i=1:length(autocorrelacao)
    fprintf(fid1,',R_%d',lags(i));
end
fprintf(fid1,'\n');

fprintf(fid1,'%s,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f', ...
    nome,vmax,vmin,vpp,vmed,vstd,energy,potencia);

for i=1:length(autocorrelacao)
    fprintf(fid1,',%.6f',autocorrelacao(i));
end
fprintf(fid1,'\n');

fclose(fid1);

end