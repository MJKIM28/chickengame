%% Iterative chicken game 
% Main code

% Parameters 'exchange','rush','avoid','unfair','undefined' can be changed.
% For parameter setting, refers to Lee et al., 2015

% 'cox_mutulP_simul' fucntion simulates the artificial agent's behavior
% according to the result of previous trial.

% The behavioral results saved as 'result.mat'.

% The reward setting can be changed in 'cox_mutualP_simul' function and
% 'random_simul' function.


% Code written by Sangho Lee. 
% For any questions, please contact to Minju Kim (mjkim28@unist.ac.kr)

%%

clear all
close all
clc

global rsum1
global rsum2

rsum1 = ones(1,2)*20000; %initial sum of reward for each player
rsum2 = ones(1,2)*20000;


%% Parameter values for each of four patterns + undefined pattern

% alpha, gamma, beta, theta of the artificial agent
% retention parameter -> gamma = 0.110214129 & sensitivity to the reciprocity -> theta = 0.609932437
exchange = [0.986359191	0.110214129	0.068871041 0.709932437];
rush = [0.86323849 0.673074352 -0.738832267	0.696529261];
avoid = [0.864833547 0.37028665	0.126612251	0.978597705];
unfair = [0.644289704 0.93032074 0.96829209	0.931588575];
undefined = [0.825579952 0.574112545 -0.200593519 0.646369624];

plot(1);
set(gcf,'Units', 'Normalized', 'OuterPosition', [0 0 1 1])
set(gcf,'color','w','menubar','none')

%% Simulated action for each pattern
%% exchange -> rush -> exchange
exchangeSimul = cox_mutualP_simul(exchange, 50, 1);
rushSimul = cox_mutualP_simul(rush, 50, 2);
exchangeSimul = cox_mutualP_simul(exchange, 50, 3);

%% exchange -> random -> exchange
% exchangeSimul = cox_mutualP_simul_new(exchange, 100, 1);
% randomSimul = random_simul(rush, 50, 2); % Any value can be put into rush
% exchangeSimul = cox_mutualP_simul_new(exchange, 50, 3);

%% save
result = struct('act1',b_act1,'act2',b_act2,'act3',b_act3,'time1',b_time1,'time2',b_time2,'time3',b_time3);
save('result.mat','result')
