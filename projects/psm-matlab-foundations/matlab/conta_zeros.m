
conta_zeros=0;
for i=1:lenght(x)
if x(i)<0 & x(i+1)>0
    conta_zeros=conta_zeros+1
end
if x(i)>0 & x(i+1)<0
    conta_zeros=conta_zeros+1
end
end
      