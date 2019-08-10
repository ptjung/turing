
# Turing
A repository for my solo Turing projects.

<hr>

#### Neural Network
The first ever neural network in Turing! This includes a test program and a neural network class -- it takes in sets of input and output from the named <tt>.txt</tt> files in its directory. Then, new output is generated over input (<tt><i>i{ i}</i></tt>) from the user interface.

Please note that the constants in the program's code, that is <tt>INPUT_SET_COUNT</tt> and <tt>INPUT_PARAM_COUNT</tt>, must match the rows and columns in the input <tt>.txt</tt> file, respectively. Also, know that the input <tt>.txt</tt> file can accept multiple input parameters (columns), but the output <tt>.txt</tt> file can accept only one parameter.

<a href="https://github.com/PtJung/Turing/tree/master/neural-network">Link</a>, updated last on August 9, 2019.

#### Credits
The code used in this neural network is based on the code in <a href="https://www.kdnuggets.com/2018/10/simple-neural-network-python.html">this article</a>, written by **Dr. Michael J. Garbade**.
<hr>

#### Animated Graphing Calculator
A basic graphing calculator made for animation purposes. For users, you must manually complete the right side of the equation on line <b>20</b> to begin usage, using any of <tt>x</tt> or <tt>k</tt>. View the documentation for the function <tt>getEquationRS()</tt> for more information.

<a href="https://github.com/PtJung/Turing/blob/master/animated-graphing-calculator.t">Link</a>, updated last on March 19, 2019.
<hr>

#### Inscribed Square Problem Visualizer
When people come across the unsolved inscribed square problem (aka. square peg problem, Toeplitz' conjecture), they are often curious enough to test and see if their own curves have any squares inscribed in them or not. This program allows people to do just that, as this program searches for and finds a square in the doodles made by the users (even though only a Jordan curve is expected).

This program works by prompting the user for some drawing. The drawing is then refined such that the edges are completely covered, so that the curve is legitimate. It will then create a side length from one point to every other point, and repeating this process for all points. Using the distance between the two points, the side length, the remaining points should be perpendicular to both points, at the same distance and perpendicular to the original side length. If the two other points are tested to be on the doodle, a square has been formed.

<a href="https://github.com/PtJung/Turing/blob/master/inscribed-square-problem-visualizer.t">Link</a>, updated last on March 19, 2019.
</pre>
<hr>

#### Animated Spiral Drawer
An animated trigonometric spiral that expands from the center of the screen indefinitely, made up of lines throughout. I used the unit circle as a reference, and for each degree, I add on 1% of its current radius to create a new radius, which creates the "exponential effect".

All lines were originally made to connect to each other, but playing around with what the lines had connected to allowed me to create such a pattern.

<a href="https://github.com/PtJung/Turing/blob/master/animated-spiral-drawer.t">Link</a>, updated last on March 19, 2019.
