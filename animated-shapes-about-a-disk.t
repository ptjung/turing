setscreen ("graphics:1000;1000")

%%%%%
%
%        Author:    Patrick Jung
%       Version:    2019-04-07
%   Description:    This program draws a variety of near-symmetrical patterns and shapes about a disk.
%
%%%%%

% Declarations
const s := 1
const rx := 300
const ry := 75

var ax, ay, cx, cy : int
var a : real

% Main loop
loop
    a := 0
    randint (ax, -rx * 2, rx * 2)
    randint (ay, -rx * 2, rx * 2)

    % Inner loop, where 'i' is represents an angle in degrees
    for i : 0 .. 359 by s

	% Line coordinates (ax, ay) from center of window to get (cx, cy)
	cx := maxx div 2 + round (cos (a) * ax)
	cy := maxy div 2 + round (sin (a) * ay)

	% Avoid any zero division errors by not permitting zero denominators
	if (maxx div 2 - cx) not= 0 then

	    % Symmetry 1 of shape
	    drawline (maxx div 2 - round (cos (arctan (- (maxy div 2 - cy) / (maxx div 2 - cx))) * rx), maxy div 2 - round (sin (arctan (- (maxy div 2 - cy) / (maxx div 2 - cx))) * ry), cx, cy, black)
	    drawline (maxx div 2 - round (-cos (arctan (- (maxy div 2 - cy) / (maxx div 2 - cx))) * rx), maxy div 2 - round (-sin (arctan (- (maxy div 2 - cy) / (maxx div 2 - cx))) * ry), cx, cy,
		black)

	    % Symmetry 2 of shape
	    drawline (maxx div 2 - round (sin (arctan (- (maxy div 2 - cy) / (maxx div 2 - cx))) * rx), maxy div 2 - round (cos (arctan (- (maxy div 2 - cy) / (maxx div 2 - cx))) * ry), cx, cy, black)
	    drawline (maxx div 2 - round (-sin (arctan (- (maxy div 2 - cy) / (maxx div 2 - cx))) * rx), maxy div 2 - round (-cos (arctan (- (maxy div 2 - cy) / (maxx div 2 - cx))) * ry), cx, cy,
		black)

	end if

	% Step for 'a', which goes up to 2 * pi
	a := s * (a + Math.PI / 180)

	delay (1)
	
    end for

    % Reset: screen, after each finished creation
    delay (100)
    cls
    
end loop
