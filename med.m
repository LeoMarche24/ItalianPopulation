function m = med(vec)
flag = 0;
x = 1;
sum1 = 0;
sum2 = 0;
m = 0;
while (flag == 0)
    for i=1:x
        sum1 = sum1 + vec(i);
    end
    for i = x:length(vec)
        sum2 = sum2 + vec(i);
    end
    if (sum1 > sum2)
        flag = 1;
    else
        x = x+1;
        sum1 = 0;
        sum2 = 0;
    end
end
m = x;    