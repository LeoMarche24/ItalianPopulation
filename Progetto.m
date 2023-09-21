%% First exploratory with raw data
totale = xlsread('totale 2002-2019.xls', 'B5:S105');
anni = 2002:2019;
len = length(anni);
y = xlsread('Fertility rate.xls', 'B2:S35');

for i=anni
    bar(totale(:,i-((anni(1)-1))), 'b')
    axis([0 100 0 12e5])
    pause(0.1)
end
%% Biplot of the median of the population
figure
axis equal
subplot(2,1,1);
bar(totale(:, 1), 'b')
hold on
pop50 = 0:5000:1000000;
n = size(pop50);
y = zeros(n(2));
y = y+med(totale(:, 1));
plot(y,pop50, '*g', 'Markersize', 3)
legend('population', 'median')
subplot(2,1,2);
n = size(totale);
gr=zeros(n(1), 1);
a = totale(:, 18);
gr(1:end-17) = a(18:end);
bar(gr, 'b')
hold on
pop50 = 0:5000:1000000;
n = size(pop50);
y = zeros(n(2));
y = y+med(a);
plot(y,pop50, '*g', 'Markersize', 3)

%% Storage of the eigenvalues
eig = [];
L1 = zeros(100,100);
for i=1:(len-1)
   
    L = zeros(100,100);
    xn_2 = totale(:, i+1);
    xn_1 = totale(:, i);
    y_aux = y(:, i);
    for i=18:49
        L(1,i) = (y_aux(i-17)/2000);
    end
    for i=2:100
        L(i,i-1) = min(1,xn_2(i)/xn_1(i-1));
    end
[w, W] = eigs(L);
%I take only the last evaluations to perform the mean, this parameter can
%be changed according to the user
if (i > 14)
    L1 = L1 + L;
end

eig = [eig max(abs(diag(W)))];
    
end
L1 = L1/(len-1)

plot(eig)

%% How goes the model?
pop50 = totale(1:100, 1);

%I use the last evaluation of the Leslie matrix
for i = 1:len
    pop50 = L*pop50;
end

pr = norm(pop50,1);
rd = norm(totale(1:100, len),1);
err = (abs(pr-rd))/rd;
figure
hold on
plot(pop50, 'LineWidth', 3, 'Color', [0.1, 0.9, 0.1])
plot(totale(:, len), 'LineWidth', 3, 'Color', [0.1, 0.1, 0.9])
title('Population in 2019, total error:', err)
legend('Projection', 'Real data')
% Not too bad

%I use the mean of the last evaluations of the Leslie matrix
pop50 = totale(1:100, 1);

for i = 1:len
    pop50 = L1*pop50;
end

pr = norm(pop50,1);
rd = norm(totale(1:100, len),1);
err = (abs(pr-rd))/rd;
figure
hold on
plot(pop50, 'LineWidth', 3, 'Color', [0.1, 0.9, 0.1])
plot(totale(:, len), 'LineWidth', 3, 'Color', [0.1, 0.1, 0.9])
title('Population in 2019, total error:', err)
legend('Projection', 'Real data')
% Better the mean evaluation (as expected)

%%
plot(eig, 'LineWidth', 3, 'Color', [0.1, 0.1, 0.9])
title('Dominant eigenvalues during the historic series')

[w,W] = eigs(L1);

%% Asymptotic analysis
auto = w(:, 1);
res = totale(1:100, len);
pop50 = res;
pop100 = res;
for i = 1:31
    pop50 = L1*pop50;
end
for i = 1:81
    pop100 = L1*pop100;
end
p50 = norm(pop50,1)
p100 = norm(pop100,1)
asymauto = abs(auto/(norm(auto)));
mauto = med(asymauto)
asym19 = totale(1:100, len)/norm(totale(1:100, len));
asympop50 = pop50/norm(pop50);
asympop100 = pop100/norm(pop100);
figure
hold on
plot(asymauto, 'LineWidth', 3, 'Color', [0.9, 0.1, 0.1])
plot(asym19, 'LineWidth', 3, 'Color', [0.1, 0.9, 0.1])
plot(asympop50, 'LineWidth', 3, 'Color', [0.1, 0.1, 0.9])
plot(asympop100, 'LineWidth', 3, 'Color', [0.1, 0.9, 0.9])
legend('Eigenvector', 'Real data 2019', 'Projection 2050', 'Projection 2100')

%% Numbers of retirements

norm(pop50,1)
norm(pop100, 1)

figure
hold on
plot(totale(1:100, len), 'LineWidth', 3, 'Color', [0.1, 0.9, 0.1])
m = med(totale(1:100, len))
plot(pop50,'LineWidth', 3, 'Color', [0.1, 0.1, 0.9])
m = med(pop50)
plot(pop100, 'LineWidth', 3, 'Color', [0.9, 0.1, 0.1])
m = med(pop100)
legend('2019','2050','2100')
work50 = [pop50(21:62)' zeros((100-63), 1)'];
work100 = [pop100(21:62)' zeros((100-63), 1)'];
ret50 = [zeros((62-21), 1)' pop50(63:100)'];
ret100 = [zeros((62-21), 1)' pop100(63:100)'];

w50 = norm(work50,1)
w100 = norm(work100,1)
r50 = norm(ret50,1)
r100 = norm(ret100,1)

margin = (w50-r50)/r50
margin2 = (w100-r100)/r100

%% Prova grafico colorato

bar(work50, 'g')
hold on
bar(ret50, 'b')
legend('Workers', 'Retired')
title('Social securities in 2050')

figure
bar(work100, 'g')
axis([0 80 0 8e5])
hold on
bar(ret100, 'b')
legend('Workers', 'Retired')
title('Social securities in 2100')

%% If fertility rate change

Lmod = zeros(100,100);
for i = 1:100
    Lmod(1,i) = 1.2*L1(1,i);
    for j = 2:100
        Lmod(j,i) = L1(j,i);
    end
end

pop50b = res;
pop100b = res;
for i = 1:31
    pop50b = Lmod*pop50b;
end
for i = 1:81
    pop100b = Lmod*pop100b;
end

[wchanged, Wchanged] = eigs(Lmod);

plot(totale(:, 18), 'LineWidth', 3, 'Color', [0.9, 0.1, 0.1])
hold on
plot(pop50b, 'LineWidth', 3, 'Color', [0.1, 0.9, 0.1])
m50 = med(pop50b)
plot(pop100b, 'LineWidth', 3, 'Color', [0.1, 0.1, 0.9])
m100 = med(pop100b)

legend('2019','2050','2100')

work50b = [];
work100b = [];
ret50b = [];
ret100b = [];
for i = 21:62
    work50 = [work50b pop50b(i)];
    work100 = [work100b pop100b(i)];
end
for i=62:100
    ret50 = [ret50b pop50b(i)];
    ret100 = [ret100b pop100b(i)];
end

w50 = norm(work50,1)
w100 = norm(work100,1)
r50 = norm(ret50,1)
r100 = norm(ret100,1)

margin = (w50-r50)/r50
margin100 = (w100-r100)/r100

%% Dynamic on projection

for i=anni
    bar(totale(:,i-2001), 'b')
    title(i)
    axis([0 100 0 12e5])
    pause(0.1)
end

x = totale(1:100, len);
pause(0.5)
%xx = 0:5000:12e5;
%yy = zeros(size(xx));
for i = 1:81
    %m = med(x)
    bar(x,'g')
    %hold on
    %plot (m+yy, xx, '*r')
    axis([0 100 0 12e5])
    j = i+2019;
    title(j)
    pause(0.1)
    %hold off
    x = L*x;
end