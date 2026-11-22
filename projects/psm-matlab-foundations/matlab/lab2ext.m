
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

% SUAVIZACAO
M=3;
y_suave=filter(ones(1,M)/M,1,xn);

% REMOCAO DA MEDIA
y_sem_media=xn-mean(xn);

% CONTAGEM DE ZEROS SEM HISTERESE
conta_zeros=0;

for i=2:length(xn)
    if xn(i-1)<0 & xn(i)>0
        conta_zeros=conta_zeros+1;
    end
    if xn(i-1)>0 & xn(i)<0
        conta_zeros=conta_zeros+1;
    end
end

% CONTAGEM DE ZEROS COM HISTERESE
VTH=0.2;
VTL=-0.2;
conta_zeros_h=0;
estado=0;

for i=1:length(xn)
    if xn(i)>VTH
        if estado==-1
            conta_zeros_h=conta_zeros_h+1;
        end
        estado=1;
    end

    if xn(i)<VTL
        if estado==1
            conta_zeros_h=conta_zeros_h+1;
        end
        estado=-1;
    end
end

fid1=fopen('parametros_do_sinal.csv','w');

if fid1==-1
    error('Houve erro na criacao do ficheiro')
end

fprintf(fid1,'Nome,Vmax,Vmin,Vpp,Vmed,DesvioPadrao,Energia,Potencia');

for i=1:length(autocorrelacao)
    fprintf(fid1,',R_%d',lags(i));
end

fprintf(fid1,',M,VTH,VTL,ZerosSemHisterese,ZerosComHisterese');

for i=1:length(y_suave)
    fprintf(fid1,',Suave_%d',i);
end

for i=1:length(y_sem_media)
    fprintf(fid1,',SemMedia_%d',i);
end

fprintf(fid1,'\n');

fprintf(fid1,'%s,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f',nome,vmax,vmin,vpp,vmed,vstd,energy,potencia);

for i=1:length(autocorrelacao)
    fprintf(fid1,',%.6f',autocorrelacao(i));
end

fprintf(fid1,',%d,%.2f,%.2f,%d,%d',M,VTH,VTL,conta_zeros,conta_zeros_h);

for i=1:length(y_suave)
    fprintf(fid1,',%.6f',y_suave(i));
end

for i=1:length(y_sem_media)
    fprintf(fid1,',%.6f',y_sem_media(i));
end

fprintf(fid1,'\n');

fclose(fid1);

end