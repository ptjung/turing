setscreen ("graphics:800;800")

%%%%
%          Name: Patrick Jung
%          Date: 2019-03-19
%   Description: An animated, trigonometric spiral on an 800 * 800 plane from the center of the screen.
%               
%                Note: let the loop go on for too long and an exception related to trigonometric function overflows may occur. 
%%%%            

% Declarations
const midx := maxx div 2
const midy := maxy div 2
const pi := 3.1415927
const multiplier := 1.01
const step := 1 / (2 * pi)

var i, r : real := 0

% Main loop
loop

    % Initialize: variables for the step-th spiral
    i := i + step
    r := 1
    
    % Display: one round of spiral
    loop
	i := i + step
	r := r * multiplier
	exit when (r > 500) or ((i + step) >= maxint) 
	drawline (midx + round ((r / multiplier) * cos (i - 1)), midy + round ((r / multiplier) * sin (i - 1)), midx + round (r * cos (i)), midy + +round (r * sin (i)), black)
    end loop
    
    % Reset: 'i'
    if (i + step) >= maxint then
	i := 0
    end if
    
    % Reset: screen
    delay (80)
    cls
    
end loop
