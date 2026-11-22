fs=1000
f=5
t=1:fs:1
x=sin(2*pi*f*t)

conta_zeros=0;
for i=2:length(x)
if x(i-1)<0 & x(i)>0
    conta_zeros=conta_zeros+1
end
if x(i-1)>0 & x(i)<0
    conta_zeros=conta_zeros+1
end
end
      