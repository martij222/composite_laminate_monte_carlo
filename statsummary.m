function [ statistics ] = statsummary( strength_ratios )
%statsummary Descriptive statistics for the datasets in the strength_ratios
%matrix
%   Detailed explanation goes here

[~,n] = size(strength_ratios);
minimum = zeros(n,1); maximum = zeros(n,1); Q1  = zeros(n,1);
Q2 = zeros(n,1); Q3 = zeros(n,1); average = zeros(n,1);
standard_deviation = zeros(n,1); IQR = zeros(n,2); CI_95pct = zeros(n,2);
for i=1:n
    minimum(i) = min( strength_ratios(:,i) );
    maximum(i) = max( strength_ratios(:,i) );
    Q = prctile(strength_ratios(:,i), [25 50 75]);
    Q1(i) = Q(1); Q2(i) = Q(2); Q3(i) = Q(3);
    average(i) = mean( strength_ratios(:,i) );
    standard_deviation(i) = std( strength_ratios(:,i) );
    IQR(i,:) = [Q(1) Q(3)];
    CI_95pct(i,:) = [average(i)-1.96*standard_deviation(i) average(i)+1.96*standard_deviation(i)];
end

%statistics = ['minimum';'Q1';'median';'Q3';'maximum';'mean';'standard deviation';'95% CI'];
failure_theory = {'max stress'; 'max strain'; 'tsai-hill'; 'modified tsai-hill'};
statistics = table(failure_theory, minimum, Q1, Q2, Q3, maximum, average, standard_deviation, IQR, CI_95pct);
statistics.Properties.RowNames = statistics.failure_theory;
statistics.failure_theory = [];
statistics.Properties.VariableNames{'Q2'}='median';
statistics.Properties.VariableNames{'average'}='mean';
statistics.Properties.VariableNames{'standard_deviation'}='SD';
end

