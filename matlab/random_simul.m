function act=random_simul(x, times, line)

global TIME
global isPushed  
global rsum1
global rsum2

% Elements of matrix for parameters of the artificial agent 
alpha= x(1);
beta= x(2); % the rate of retention of reciprocity
gamma = x(3); % the initial benevolence parameter
theta = x(4); % the relative weight of the other's kindness

% Probability of the artificial agent
p = 0.5; %'s ininitial probability of avoid
pa = zeros(times,1); % The storage of the probability of taking action for each subject

act = zeros(times,2); % The storage of action results
time = zeros(times,2); % The storage of action times

rep = zeros(2,2); %player, reputation [0 0; 0 0]
reward = [-1000 300 -300 0]; %reward setting
% rsum1 = ones(1,2)*200; %initial sum of reward for each player
% rsum2 = ones(1,2)*200;

uLog = zeros(times,2); % the storage of utility values
 
point=[-0.5 0.5]; % kindness value; -0.5 = rush, 0.5 = avoid





%% image load
IMG_carLeft = imread('car_left.png');
IMG_carRight = imread('car_right.png');
IMG_crush = imread('crush.png');

%% {times} TRIAL
for n=1:times
    
    isPushed = 0;
    TIME = 0;
        
    
    %% take actions with the probabilities updated in the previous trial
    % Determine the action of the artificial agent 
    act(n,1) = rand < 0.5;
    disappear = 5;
    
    %-- update of kindness. rep(1,1) ~ kindness of self, rep(1,2) ~
    %kindness of other    
    rep(1,1) = beta*rep(1,1)+point(act(n,1)+1); % eq(7) of Lee et al. (2015)       
    rep(1,2) = beta*rep(1,2)+point(act(n,2)+1)+gamma;    
    
    %-- update of emotional state (reciprocity). eq(8) of Lee et al. (2015)
    emotion1 = 2*(theta*rep(1,2)-((1-theta)*rep(1,1)));    

    %-- update of utility. eq(9) of Lee et al. (2015)
    uAvoid = ((rsum1(1) - 0.5)^alpha + emotion1*((rsum1(2) + 0.5)^alpha))/alpha;
    uRush = ((rsum1(1) - 0.5)^alpha + emotion1*((rsum1(2) - 1.5)^alpha))/alpha;
    
    uLog(n,1)=uAvoid; uLog(n,2)=uRush;
    
    %-- update of the probability of avoid. eq(10) of Lee et al. (2015)
    z=(uAvoid-uRush); 
    p(1)=1/(1+exp(-(z))); %logistic sigmoid
    pa(n,1)=p(1);    
    
    if act(n,1) == 0 
        time(n,1) = 0;
    end
    
    %-- the artificial agent avoids 
    if act(n,1) == 1
        % Regardless of the setting of the moment of disappearance (in
        % sec), the the artificial agent always disappear right before
        % crushing
        % disappear in 1sec - disappear when disappear == 1 
        if rand < 1/6
            disappear = 3;
            time(n,1) = 1;
            % disappear in 1-2sec - disappear when disappear == 2 
        elseif 1/6 < rand && rand < 2/6
            disappear = 3;
            time(n,1) = 2;
            %disappear in 2-3sec - disappear when disappear == 3 
        elseif rand > 2/6
            disappear = 3;
            time(n,1) = 3;
        end
    end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%SCREEN%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %Initial screen
     a = 0;
     if n == 1 && line == 1
         subplot(3,7,4); text(-0.5,0.5,'Loading','fontsize',80); axis off; 
         subplot(3,7,21); image(IMG_carRight); axis off; 
         subplot(3,7,7); text(0.5,0.5,'Player1','FontSize',30); axis off;     
         drawnow;
         pause(15);
     end
     tic;
     while a<2
        a = toc;
        
        clf;
        subplot(3,7,4); text(-0.5,0.5,'Ready','fontsize',80); axis off; 
        subplot(3,7,15); image(IMG_carLeft); axis off 
        subplot(3,7,21); image(IMG_carRight); axis off;
        subplot(3,7,1); text(0.5,0.5,'Player2','FontSize',30); axis off;     
        subplot(3,7,7); text(0.5,0.5,'Player1','FontSize',30); axis off;      
        subplot(3,7,8); text(0.5,0.5,num2str(rsum1(1,1)),'FontSize',30); axis off;
        subplot(3,7,14); text(0.5,0.5,num2str(rsum2(1,1)),'FontSize',30); axis off;        
 
        drawnow;
     end

     
     
    TIME1 = keyPress;
    
    %disp(TIME1);
     
    if TIME1 > 0
       realtime = TIME1;
    end

      
    %-- Start 3sec countdown
    a = 0;
    tic;
    while a<3 
      a =toc;
      
      if 0<a && a<1
       clf;
         if ~(act(n,1) == 1 && isPushed)
            subplot(3,7,15); image(IMG_carLeft); axis off;
         end
       
         if ~isPushed
             subplot(3,7,21); image(IMG_carRight); axis off;
         end
         
       subplot(3,7,4); text(0.5,0.5,'3','FontSize',80); axis off;
       subplot(3,7,8); text(0.5,0.5,num2str(rsum1(1,1)),'FontSize',30); axis off;
       subplot(3,7,14); text(0.5,0.5,num2str(rsum2(1,1)),'FontSize',30); axis off;
       subplot(3,7,1); text(0.5,0.5,'Player2','FontSize',30); axis off;     
       subplot(3,7,7); text(0.5,0.5,'Player1','FontSize',30); axis off;      
        
       drawnow
       
      end
   
      if 1<a && a<2
       clf;
       
       if disappear > 1
          if ~(act(n,1) == 1 && isPushed)
            subplot(3,7,16); image(IMG_carLeft); axis off;
          end
       end
       
       if ~isPushed
            subplot(3,7,20); image(IMG_carRight); axis off;
       end
       
       subplot(3,7,4); text(0.5,0.5,'2','FontSize',80); axis off;
       subplot(3,7,8); text(0.5,0.5,num2str(rsum1(1,1)),'FontSize',30); axis off;
       subplot(3,7,14); text(0.5,0.5,num2str(rsum2(1,1)),'FontSize',30); axis off;
       subplot(3,7,1); text(0.5,0.5,'Player2','FontSize',30); axis off;     
       subplot(3,7,7); text(0.5,0.5,'Player1','FontSize',30); axis off;
       drawnow
      end
   
      if 2<a && a<3
       clf;
       
       if disappear > 2
          if ~(act(n,1) == 1 && isPushed)
             subplot(3,7,17); image(IMG_carLeft); axis off;
          end
       end
       
       if ~isPushed
        subplot(3,7,19); image(IMG_carRight); axis off;
       end
       
       subplot(3,7,4); text(0.5,0.5,'1','FontSize',80); axis off;
       subplot(3,7,8); text(0.5,0.5,num2str(rsum1(1,1)),'FontSize',30); axis off;
       subplot(3,7,14); text(0.5,0.5,num2str(rsum2(1,1)),'FontSize',30); axis off;
       subplot(3,7,1); text(0.5,0.5,'Player2','FontSize',30); axis off;     
       subplot(3,7,7); text(0.5,0.5,'Player1','FontSize',30); axis off;
       drawnow
      end
      
    end
    
    
    %% Crush
    if act(n,1) == 0 && ~isPushed
      clf;
      a = 0;
      
      tic;
      while a<1
        a = toc;
        subplot(3,7,18); image(IMG_crush); axis off;
        subplot(2,7,4); text(-0.5,0.5,'Draw','fontsize',80); axis off;
        subplot(3,7,8); text(0.5,0.5,num2str(rsum1(1,1)),'FontSize',30); axis off;
        subplot(3,7,14); text(0.5,0.5,num2str(rsum2(1,1)),'FontSize',30); axis off;
        subplot(3,7,1); text(0.5,0.5,'Player2','FontSize',30); axis off;     
        subplot(3,7,7); text(0.5,0.5,'Player1','FontSize',30); axis off;
        drawnow;

      end
      
      r1(1) = reward(2*act(n,1)+act(n,2) + 1); 
      r1(2) = reward(2*act(n,2)+act(n,1) + 1); 
      rsum1 = rsum1+r1;
      rh(n,1:2) = rsum1;

      r2(1,1) = reward(2*act(n,2)+act(n,1) + 1);   
      r2(1,2) = reward(2*act(n,1)+act(n,2) + 1);
      rsum2 = rsum2+r2;       
      
      continue;
      
    end
    
    %% Computer win
    if act(n,1) == 0 && isPushed
        a = 0;
        
        tic;
        while a<2
            a = toc;
        
            if 0<a && a<1
               clf;
               subplot(3,7,18); image(IMG_carLeft); axis off;
               subplot(3,7,8); text(0.5,0.5,num2str(rsum1(1,1)),'FontSize',30); axis off;
               subplot(3,7,14); text(0.5,0.5,num2str(rsum2(1,1)),'FontSize',30); axis off;
               subplot(3,7,1); text(0.5,0.5,'Player2','FontSize',30); axis off;     
               subplot(3,7,7); text(0.5,0.5,'Player1','FontSize',30); axis off;
               drawnow;
            end
            
            if 1<a && a<2
               clf;
               subplot(3,7,19); image(IMG_carLeft); axis off;
               subplot(3,7,8); text(0.5,0.5,num2str(rsum1(1,1)),'FontSize',30); axis off;
               subplot(3,7,14); text(0.5,0.5,num2str(rsum2(1,1)),'FontSize',30); axis off;
               subplot(3,7,1); text(0.5,0.5,'Player2','FontSize',30); axis off;     
               subplot(3,7,7); text(0.5,0.5,'Player1','FontSize',30); axis off;
               subplot(2,7,4); text(-0.5,0.5,'Lose','fontsize',80); axis off;
               drawnow;
            end
        end
    end
    
    
    %% User Win
    if act(n,1) == 1 && ~isPushed
        a = 0;
        
        tic;
        while a<2
            a = toc;
        
            if 0<a && a<1
               clf;
               subplot(3,7,18); image(IMG_carRight); axis off;
               subplot(3,7,8); text(0.5,0.5,num2str(rsum1(1,1)),'FontSize',30); axis off;
               subplot(3,7,14); text(0.5,0.5,num2str(rsum2(1,1)),'FontSize',30); axis off;
               subplot(3,7,1); text(0.5,0.5,'Player2','FontSize',30); axis off;     
               subplot(3,7,7); text(0.5,0.5,'Player1','FontSize',30); axis off;
               drawnow;
            end
            
            if 1<a && a<2
               clf;
               subplot(3,7,17); image(IMG_carRight); axis off;
               subplot(3,7,8); text(0.5,0.5,num2str(rsum1(1,1)),'FontSize',30); axis off;
               subplot(3,7,14); text(0.5,0.5,num2str(rsum2(1,1)),'FontSize',30); axis off;
               subplot(3,7,1); text(0.5,0.5,'Player2','FontSize',30); axis off;     
               subplot(3,7,7); text(0.5,0.5,'Player1','FontSize',30); axis off;
               subplot(3,7,4); text(0,0.5,'Win','fontsize',80); axis off;
               drawnow;
            end
        end
    end    

    
    % when the player pushed
    if isPushed
        act(n,2) = 1;
    end
    
    time(n, 2) = TIME;


   
    %% Updates of player 1
    %-- calulate reward of both players in the perspective of player 1
    r1(1) = reward(2*act(n,1)+act(n,2) + 1); % = -1 player 1's reward
    r1(2) = reward(2*act(n,2)+act(n,1) + 1); %player 2's reward
    
    %-- calculate reward sum in the perspective of player 1
    rsum1 = rsum1+r1;
    %[200 200] + r1 [-1 1]
    
    rh(n,1:2) = rsum1;

    
    %% Updates of player 2
    %-- calulate reward of both players in the perspective of player 2
    r2(1,1) = reward(2*act(n,2)+act(n,1) + 1);   
    r2(1,2) = reward(2*act(n,1)+act(n,2) + 1);
    
    %-- calculate reward sum in the perspective of player 1
    rsum2 = rsum2+r2;    

        
end
if line == 1
    assignin('base','b_act1',act);
    assignin('base','b_time1',time);
    act
    time
elseif line == 2
    assignin('base','b_act2',act);
    assignin('base','b_time2',time);
    act
    time
else
    assignin('base','b_act3',act);
    assignin('base','b_time3',time);
    act
    time
    
    figure(1),clf,imagesc(act),colormap copper
    pause(20);
end
    
