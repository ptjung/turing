setscreen ("graphics:500;500")

%%%%%
%
%        Author:    Patrick Jung
%       Version:    2019-03-17
%   Description:    This program visualizes the inscribed square problem (aka. square peg problem, Toeplitz' conjecture), which asks if
%                   every simple closed curve contains all four verticles of some square; it will find the first square of the user's
%                   drawing on a 500 * 500 plane, upon pressing the UP arrow key. The DOWN arrow key erases everything.
%%%%%

% Declarations
const midx := maxx div 2
const midy := maxy div 2
const drawColour := 17
const squareColour := 32

var arbitraryTestPoints : array 1 .. maxx, 1 .. maxy of boolean

% Procedure:
procedure getAribtraryTestPoints
    for currX : 1 .. maxx
        for currY : 1 .. maxy
            if whatdotcolour (currX, currY) = drawColour then
                arbitraryTestPoints (currX, currY) := true
            else
                arbitraryTestPoints (currX, currY) := false
            end if
        end for
    end for
end getAribtraryTestPoints

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
    var pointOnHoriX, pointOnHoriY, pointOnDiagX, pointOnDiagY : int
    var distBtwPoints, degree : real

    getAribtraryTestPoints

    % Tests with possible coordinates with every side lengths (minRad to maxRad units) of the possible square
    for currX : 1 .. maxx
        for currY : 1 .. maxy

            % Tests if the current point is filled; if so, continue
            if whatdotcolour (currX, currY) = drawColour then

                for pointOnForwX : 1 .. maxx
                    for pointOnForwY : 1 .. maxy
                        if arbitraryTestPoints (pointOnForwX, pointOnForwY) then
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

                arbitraryTestPoints (currX, currY) := false
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
