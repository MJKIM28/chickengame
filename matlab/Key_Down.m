function Key_Down(scr,event)

global isPushed
global TIME
global tHand

if ~isPushed
    isPushed = 1;
    TIME = toc(tHand);
    %TIME
end
