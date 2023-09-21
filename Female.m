%% Upload of the data

femmine = xlsread('Femmine 2002-2019.xls', 'B3:S103');
maschi = xlsread('Divisione per genere.xls', 'B3:S103');
anni = 2002:2019;
len = length(anni);

y = xlsread('Fertility rate.xls', 'B2:S35');

%% Storage of the eigenvalues
eigf = [];
eigm = [];

L1f = zeros(100,100);
L1m = zeros(100,100);

for i=1:(len-1)
   
    Lf = zeros(100,100);
    Lm = zeros(100,100);

    xf_2 = femmine(:, i+1);
    xf_1 = femmine(:, i);
    xm_2 = maschi(:, i+1);
    xm_1 = maschi(:, i);
    
    y_aux = y(:, i);

    for i=18:49
        Lf(1,i) = (y_aux(i-17)/2000);
        Lm(1,i) = (y_aux(i-17)/2000);
    end
    for i=2:100
        Lf(i,i-1) = min(1,xf_2(i)/xf_1(i-1));
        Lm(i,i-1) = min(1,xm_2(i)/xm_1(i-1));
    end
[wf, Wf] = eigs(Lf);
[wm, Wm] = eigs(Lm);

%I take only the last evaluations to perform the mean, this parameter can
%be changed according to the user
if (i > 14)
    L1f = L1f + Lf;
    L1m = L1m + Lm;
end

eigf = [eigf max(abs(diag(Wf)))];
eigm = [eigm max(abs(diag(Wm)))];
    
end
L1f = L1f/(len-1)
L1m = L1m/(len-1)

%% dominant eigenvalues
plot(eigf, 'LineWidth', 3, 'Color', [0.1, 0.1, 0.9])
hold on
plot(eigm, 'LineWidth', 3, 'Color', [0.9, 0.1, 0.1])
legend('females', 'males')
title('Dominant eigenvalues during the historic series')

% No differences at all
