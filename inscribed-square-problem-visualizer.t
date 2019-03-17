setscreen ("graphics:500;500")

%%%%%
%
%        Author:    Patrick Jung
%       Version:    2019-03-17
%   Description:    This program visualizes the inscribed square problem (aka. square peg problem, Toeplitz' conjecture), which asks if
%                   every simple closed curve contains all four verticles of some square; it will find the first square of the user's
%                   drawing, upon pressing the UP arrow key. The DOWN arrow key erases everything.
%
%                   This program is not made to keep up with very fast doodles; it is recommended that the user draws slowly, so that
%                   the drawing is fully filled. The program's performance is based on how much has been drawn on the screen and the
%                   size of the shape.
%
%%%%%

% Declarations
const midx := maxx div 2
const midy := maxy div 2
const drawColour := 17
const squareColour := 32

% Function: calculate the longest distance from one dot to a set of dots and return that value
function calcLongestDist (currX : int, currY : int) : real
    var maxDist, currDist : real := 0
    for x : 1 .. maxx
        for y : 1 .. maxy
            if whatdotcolour (x, y) = drawColour then
                currDist := sqrt ((currX - x) ** 2 + (currY - y) ** 2)
                if maxDist < currDist then
                    maxDist := currDist
                end if
            end if
        end for
    end for
    result maxDist
end calcLongestDist

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

% Procedure: checks and draws a possible square (with side lengths starting from minRad units) on the user's drawing
procedure checkDrawForSquare (minRad : int)
    const rev := Math.PI * 2
    var pointOnX1, pointOnY1, pointOnX2, pointOnY2, pointOnX3, pointOnY3 : int

    % Tests with possible coordinates with every side lengths (minRad to maxRad units) of the possible square
    for currX : 1 .. maxx
        for currY : 1 .. maxy

            % Tests if the current point is filled; if so, continue
            if whatdotcolour (currX, currY) = drawColour then

                for sideLength : minRad .. round (calcLongestDist (currX, currY))

                    % Rotates a square about the current point (as the pivot), and tests if all three other points on the square match are on the plane and filled
                    for degree : 0 .. 359
                        pointOnX1 := currX + round (cos (degree / 360 * rev) * sideLength)
                        pointOnY1 := currY + round (sin (degree / 360 * rev) * sideLength)

                        if (pointOnX1 >= 1 and pointOnX1 <= maxx) and (pointOnY1 >= 1 and pointOnY1 <= maxy) and whatdotcolour (pointOnX1, pointOnY1) = drawColour then
                            pointOnX2 := currX + round (cos ((degree - 90) / 360 * rev) * sideLength)
                            pointOnY2 := currY + round (sin ((degree - 90) / 360 * rev) * sideLength)

                            if (pointOnX2 >= 1 and pointOnX2 <= maxx) and (pointOnY2 >= 1 and pointOnY2 <= maxy) and whatdotcolour (pointOnX2, pointOnY2) = drawColour then
                                pointOnX3 := currX + round (cos ((degree - 45) / 360 * rev) * sideLength * sqrt (2))
                                pointOnY3 := currY + round (sin ((degree - 45) / 360 * rev) * sideLength * sqrt (2))

                                if (pointOnX3 >= 1 and pointOnX3 <= maxx) and (pointOnY3 >= 1 and pointOnY3 <= maxy) and whatdotcolour (pointOnX3, pointOnY3) = drawColour then
                                    % All points on the square match previously filled points; therefore, the square exists, and is drawn
                                    drawPolygon (currX, currY, pointOnX1, pointOnY1, pointOnX2, pointOnY2, pointOnX3, pointOnY3, squareColour)
                                    return
                                end if

                            end if
                        end if
                    end for
                end for
            end if
        end for
    end for
end checkDrawForSquare

% Main-line logic
procedure main
    var chars : array char of boolean
    var drawXi, drawYi, drawXf, drawYf, drawB : int

    loop
        % Input via mouse
        mousewhere (drawXf, drawYf, drawB)
        if drawB = 1 then
            if (drawXi >= 1 and drawXi <= maxx) and (drawYi >= 1 and drawYi <= maxy) then
                drawline (drawXi, drawYi, drawXf, drawYf, drawColour)
            end if
            drawXi := drawXf
            drawYi := drawYf
            drawB := 0
        else
            drawXi := 0
            drawYi := 0
        end if

        % Input via keyboard
        Input.KeyDown (chars)
        if chars (KEY_UP_ARROW) then
            % Checks for a square to draw, drawing it when possible
            put "TESTING FOR A SQUARE..." ..
            checkDrawForSquare (5)
            put " FINISHED DRAWING."
            delay (50)

        elsif chars (KEY_DOWN_ARROW) then
            % Resets and clears the entire screen of all text, squares, and drawings
            cls
        end if
    end loop
end main

% Run main
main
