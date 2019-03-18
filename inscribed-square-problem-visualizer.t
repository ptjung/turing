setscreen ("graphics:800;800")

%%%%%
%
%        Author:    Patrick Jung
%       Version:    2019-03-17
%   Description:    This program visualizes the inscribed square problem (aka. square peg problem, Toeplitz' conjecture), which asks if
%                   every simple closed curve contains all four verticles of some square; it will find the first square of the user's
%                   drawing on a 800 * 800 plane, if possible. Click the screen after the drawing has been tested to reset it.
%%%%%

% Declarations
const drawColour := 17
const squareColour := 32

var arbitraryTestPoints : array 1 .. maxx, 1 .. maxy of boolean

% Function: initializes all arbitrary test points, that is, all points that have been colored by the user; returns number of test points
function getArbitraryTestPoints : int
    var testPoints : int := 0

    for currX : 1 .. maxx
        for currY : 1 .. maxy
            if whatdotcolour (currX, currY) = drawColour then
                arbitraryTestPoints (currX, currY) := true
                testPoints := testPoints + 1
            else
                arbitraryTestPoints (currX, currY) := false
            end if
        end for
    end for

    result testPoints
end getArbitraryTestPoints

% Procedure: draws a polygon, given the x and y coordinates of four points, and a colour
procedure drawPolygon (px1 : int, py1 : int, px2 : int, py2 : int, px3 : int, py3 : int, px4 : int, py4 : int, customColour : int)
    const vertexRad := 2

    drawline (px1, py1, px2, py2, customColour)
    drawline (px1, py1, px3, py3, customColour)
    drawline (px2, py2, px4, py4, customColour)
    drawline (px3, py3, px4, py4, customColour)
    drawfilloval (px1, py1, vertexRad, vertexRad, black)
    drawfilloval (px2, py2, vertexRad, vertexRad, black)
    drawfilloval (px3, py3, vertexRad, vertexRad, black)
    drawfilloval (px4, py4, vertexRad, vertexRad, black)

end drawPolygon

% Procedure: checks and draws a possible square (with side lengths starting from minRad units) on the user's drawing; displays percent of checked points
procedure checkDrawForSquare (minRad : int, percColumn : int)
    const rev := Math.PI * 2
    var pointOnHoriX, pointOnHoriY, pointOnDiagX, pointOnDiagY, testPoints, testedPoints : int := 0
    var distBtwPoints, degree : real

    % Initialize arbitrary test points
    testPoints := getArbitraryTestPoints

    % Tests with possible coordinates
    for currX : 1 .. maxx
        for currY : 1 .. maxy

            % Tests if the current point is filled; if so, continue
            if whatdotcolour (currX, currY) = drawColour then

                % Finds all other filled arbitrary points
                for pointOnForwX : 1 .. maxx
                    for pointOnForwY : 1 .. maxy
                        if arbitraryTestPoints (pointOnForwX, pointOnForwY) then

                            % Checks for other side lengths of the square horizontally and vertically, on both sides
                            distBtwPoints := sqrt ((currX - pointOnForwX) ** 2 + (currY - pointOnForwY) ** 2)
                            if distBtwPoints > 5 and (pointOnForwX - currX) not= 0 then
                                degree := arctan ((pointOnForwY - currY) / (pointOnForwX - currX)) * (180 / Math.PI)

                                for side : -1 .. 1 by 2
                                    pointOnHoriX := currX + round (cos ((degree + 90 * side) / 360 * rev) * distBtwPoints)
                                    pointOnHoriY := currY + round (sin ((degree + 90 * side) / 360 * rev) * distBtwPoints)

                                    if whatdotcolour (pointOnHoriX, pointOnHoriY) = drawColour then
                                        pointOnDiagX := currX + round (cos ((degree + 45 * side) / 360 * rev) * distBtwPoints * sqrt (2))
                                        pointOnDiagY := currY + round (sin ((degree + 45 * side) / 360 * rev) * distBtwPoints * sqrt (2))

                                        if whatdotcolour (pointOnDiagX, pointOnDiagY) = drawColour then
                                            drawPolygon (currX, currY, pointOnForwX, pointOnForwY, pointOnHoriX, pointOnHoriY, pointOnDiagX, pointOnDiagY, squareColour)
                                            return
                                        end if

                                    end if
                                end for
                            end if

                        end if
                    end for
                end for

                % The tested point should not be visited again, to avoid repetition
                arbitraryTestPoints (currX, currY) := false

                % Display percentage of checked points
                locate (1, percColumn)
                testedPoints := testedPoints + 1
                put intstr (round (testedPoints / testPoints * 100)), "% CHECKED" ..

            end if
        end for
    end for
end checkDrawForSquare

% Main-line logic
procedure main
    const message := "TESTING FOR A SQUARE..."
    var chars : array char of boolean
    var drawXi, drawYi, drawXf, drawYf, drawB : int
    var hasDrawn : boolean := false

    loop
        % Input via mouse
        mousewhere (drawXf, drawYf, drawB)
        
        if (drawB = 1 and not hasDrawn) and (drawXf >= 1 and drawXf <= maxx) and (drawYf >= 1 and drawYf <= maxy) then
            % Upon button press
            mousewhere (drawXi, drawYi, drawB)
            hasDrawn := true
            cls
            
        elsif drawB = 1 and hasDrawn then
            % Upon holding down the button
            if (drawXf >= 1 and drawXf <= maxx) and (drawYf >= 1 and drawYf <= maxy) then
                drawline (drawXi, drawYi, drawXf, drawYf, drawColour)
            end if
            drawXi := drawXf
            drawYi := drawYf
            drawB := 0
            
        elsif drawB = 0 and hasDrawn then
            % Upon letting the button go
            put message + " 0% CHECKED" ..
            checkDrawForSquare (5, length (message) + 2)
            hasDrawn := false
            locate (1, length (message) + 2)
            put "FINISHED DRAWING."
            
        end if
    end loop
end main

% Run main
main
