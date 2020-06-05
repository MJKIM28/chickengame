function [out] = keyPress()
global TIME
global tHand

fHand = figure(1);clf;
set(fHand, 'KeyPressFcn', @Key_Down);

    
    tHand = tic;
    drawnow;
   %pause(3)
    out = TIME;
