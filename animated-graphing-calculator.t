%%%
%
%    Name: Patrick Jung
%    Date: 2019-03-19
%    Desc: A basic graphing calculator made for animation purposes. For users, please see and complete the right side of the equation on line 20.
%
%%%


%%%
%
%      Syntax   getEquationRS (x : real, k : real) : real
% Description   The y-value is calculated and returned given parameters x, k. In an equation, this would be the right side of it while the left side is just 'y'.
%               
%               The user of the program must manually set this equation's right side. It is defaulted at '-1'.
%               Note: the value of 'k' is initialized at 0, and for every 50 ms, increments by 1 and eventually resets upon reaching the maximum integer. This variable animates the graph.
%
%%%
function getEquationRS (x : real, k : real) : real
    result -1
end getEquationRS





% Initialize: constants (Editable by user)
% SCALE_STEPO: size (side length) of each grid cell; SCALE_STEPX: how much 'x' value each grid cell hold; SCALE_STEPY: how much 'y' value each grid cell hold
const SCALE_STEPO := 25
const SCALE_STEPX := 1
const SCALE_STEPY := 1

% Colors (grid, axis, graph) go to "http://compsci.ca/v3/download.php?id=8957" for colour reference
const GRID_COLOR := 30
const AXIS_COLOR := 28
const GRAPH_COLOR := 7

% Dimensions (PX * PY)
const PX := 900
const PY := 900

% Initialize: constants (Do not edit)
const MIDX := PX div 2
const MIDY := PY div 2

const LINE_OVERALL_X := MIDX div SCALE_STEPO
const LINE_OVERALL_Y := MIDY div SCALE_STEPO

const ZERO_DIV_CONSTANT := 0.0000001

% Initialize: variables
var graphResults : array - MIDX .. MIDX of real
var graphRestrict : array 1 .. * of int := init (minint)
var k : real := ZERO_DIV_CONSTANT
var x : real

% Initialize: screen dimensions
setscreen ("graphics:" + intstr (PX) + ";" + intstr (PY))



%%%
%
%      Syntax   scaleValueX (value : real) : real
% Description   Returns a value with scaled horizontal components.
%
%%%
function scaleValueX (value : real) : real
    result value * SCALE_STEPX / SCALE_STEPO
end scaleValueX

%%%
%
%      Syntax   scaleValueY (value : real) : real
% Description   Returns a value with scaled vertical components.
%
%%%
function scaleValueY (value : real) : real
    result value / SCALE_STEPY * SCALE_STEPO
end scaleValueY

%%%
%
%      Syntax   isValueRestrict (value : real) : boolean
% Description   Tests if the value is within the array of restrictions.
%
%%%
function isValueRestrict (value : real) : boolean
    for restrict : 1 .. upper (graphRestrict)
	if value = graphRestrict (restrict) then
	    result false
	end if
    end for
    result true
end isValueRestrict

%%%
%
%      Syntax   displayAxes
% Description   Displays the axes graphically.
%
%%%
procedure displayAxes
    for lineCountX : -LINE_OVERALL_X .. LINE_OVERALL_X
	drawline (MIDX + SCALE_STEPO * lineCountX, 0, MIDX + SCALE_STEPO * lineCountX, maxy, GRID_COLOR)
    end for
    for lineCountY : -LINE_OVERALL_Y .. LINE_OVERALL_Y
	drawline (0, MIDY + SCALE_STEPO * lineCountY, maxx, MIDY + SCALE_STEPO * lineCountY, GRID_COLOR)
    end for
    for bolding : -1 .. 1
	drawline (MIDX + bolding, 0, MIDX + bolding, maxy, AXIS_COLOR)
	drawline (0, MIDY + bolding, maxx, MIDY + bolding, AXIS_COLOR)
    end for
end displayAxes

%%%
%
%      Syntax   displayYInt
% Description   Displays the y-intercept graphically.
%
%%%
procedure displayYInt
    if isValueRestrict (0) then
	drawfilloval (MIDX, MIDY + round (scaleValueY (graphResults (0))), 3, 3, GRAPH_COLOR)
    end if
end displayYInt


loop

    % Processing: determine all values of y for the equation, for all x
    for resultX : -MIDX .. MIDX
	if isValueRestrict (resultX) then
	    x := scaleValueX (resultX) + ZERO_DIV_CONSTANT
	    graphResults (resultX) := getEquationRS (x, k)
	end if
    end for

    % Maintain frame with 'k' value
    delay (50)
    cls

    % Output: entire graph; no animation
    displayAxes
    displayYInt
    for outLine : -MIDX .. MIDX - 1
	if isValueRestrict (outLine) and isValueRestrict (outLine + 1) then
	    drawline (MIDX + outLine, MIDY + round (scaleValueY (graphResults (outLine))), MIDX + outLine + 1, MIDY + round (scaleValueY (graphResults (outLine + 1))), GRAPH_COLOR)
	end if
    end for

    % Step Value: reset when the maximum integer is reached with 'k'
    k := k + 1
    if k = maxint then
	k := 0
    end if
    
end loop
