fs=1000
f=5
t=0:1/fs:1
y=sin(2*pi*f*t)+0.1*randn(1,1001)
plot(t,y)
conta_zeros=0;
for i=2:length(y)
    if y(i)*y(i-1)<0
        conta_zeros=conta_zeros+1
    end
end
conta_zeros