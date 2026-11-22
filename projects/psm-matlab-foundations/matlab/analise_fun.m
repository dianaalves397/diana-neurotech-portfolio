function analise_fun(x,Nome)

vmax=max(x);
vmin=min(x);
vpp=vmax-vmin;
vmed=mean(x);
vstd=std(x);
energy=sum(x.^2);
potencia=energy/length(x);
x=1/n*sum(x*N )


fid1=fopen('parametros_do_sinal.csv','w');

if fid1==-1
    error('Houve erro na criacao do ficheiro')
end

fprintf(fid1,'Nome,Vmax,Vmin,Vpp,Vmed,DesvioPadrao,Energia,Potencia\n');
fprintf(fid1,'%s,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f,%.6f',Nome,vmax,vmin,vpp,vmed,vstd,energy,potencia);

fclose(fid1);
end

