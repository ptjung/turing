setscreen ("graphics:800;800")

/*
 Author: Patrick Jung
 Date: 2019-08-09 at 10:10 PM
 Description: This program is an executable that demonstrates the capabilities of a neural network
 that use I/O files to initialize its I/O sets. Please note that this program is still in development
 and changes to the number constants may result in compiler crashes.
 */

% Define constants with I/O file names, and the expected input set and parameter counts
const FILE_NAME_SET_I := "set_inputs.txt"
const FILE_NAME_SET_O := "set_outputs.txt"
const INPUT_SET_COUNT := 14
const INPUT_PARAM_COUNT := 4





% Class (NeuralNetwork): this class demonstrates the capabilities of a neural network in Turing
class NeuralNetwork

    import Math, INPUT_SET_COUNT, INPUT_PARAM_COUNT
    export disp_weights, think_proc, train

    var synaptic_weights : array 1 .. INPUT_PARAM_COUNT of real
    var vector_fx : flexible array 1 .. 0 of real

    % Procedure: neural network initialization
    procedure initialization
        for i : 1 .. INPUT_PARAM_COUNT
            synaptic_weights (i) := 2.0 * Rand.Real - 1.0
        end for
    end initialization
    initialization

    % Function: returns the sigmoid of input 'x'
    function sigmoid (x : real) : real
        result 1.0 / (1.0 + Math.E ** (-x))
    end sigmoid

    % Function: returns the sigmoid derivative of input 'f'
    function sigmoid_der (f : real) : real
        result f * (1 - f)
    end sigmoid_der

    % Procedure: apply the vector addition of two vectors to the class's flexible vector
    procedure vect_addn (param_vect1 : array 1 .. * of real, param_vect2 : array 1 .. * of real)
        new vector_fx, upper (param_vect1)
        for vect_ind : 1 .. upper (param_vect1)
            vector_fx (vect_ind) := param_vect1 (vect_ind) + param_vect2 (vect_ind)
        end for
    end vect_addn

    % Procedure: apply the vector subtraction of two vectors to the class's flexible vector
    procedure vect_subn (param_vect1 : array 1 .. * of real, param_vect2 : array 1 .. * of real)
        new vector_fx, upper (param_vect1)
        for vect_ind : 1 .. upper (param_vect1)
            vector_fx (vect_ind) := param_vect1 (vect_ind) - param_vect2 (vect_ind)
        end for
    end vect_subn

    % Procedure: apply the vector multiplication of two vectors to the class's flexible vector
    procedure vect_mult (param_vect1 : array 1 .. * of real, param_vect2 : array 1 .. * of real)
        new vector_fx, upper (param_vect1)
        for vect_ind : 1 .. upper (param_vect1)
            vector_fx (vect_ind) := param_vect1 (vect_ind) * param_vect2 (vect_ind)
        end for
    end vect_mult

    % Procedure: apply the dot product of a matrix and a vector to the class's flexible vector
    procedure dot_prod (param_matx : array 1 .. *, 1 .. * of real, param_vect : array 1 .. * of real, param_transpose : boolean)
        if param_transpose then
            % Uses the transpose of the matrix parameter
            new vector_fx, upper (param_matx, 2)
            for vect_ind : 1 .. upper (param_matx, 2)
                vector_fx (vect_ind) := 0
                for nest_ind : 1 .. upper (param_matx, 1)
                    vector_fx (vect_ind) := vector_fx (vect_ind) + param_matx (nest_ind, vect_ind) * param_vect (nest_ind)
                end for
            end for
        else
            % Uses the original matrix parameter
            new vector_fx, upper (param_matx, 1)
            for vect_ind : 1 .. upper (param_matx, 1)
                vector_fx (vect_ind) := 0
                for nest_ind : 1 .. upper (param_matx, 2)
                    vector_fx (vect_ind) := vector_fx (vect_ind) + param_matx (vect_ind, nest_ind) * param_vect (nest_ind)
                end for
            end for
        end if
    end dot_prod

    % Function: returns an output based on the input data sets
    function think_func (input : array 1 .. *, 1 .. * of real) : array 1 .. INPUT_SET_COUNT of real
        var out_dot_prod : array 1 .. INPUT_SET_COUNT of real

        dot_prod (input, synaptic_weights, false)
        for vect_ind : 1 .. INPUT_SET_COUNT
            out_dot_prod (vect_ind) := sigmoid (vector_fx (vect_ind))
        end for
        result out_dot_prod
    end think_func

    % Procedure: train the neural network using set inputs and outputs a number of times
    procedure train (set_inputs : array 1 .. *, 1 .. * of real, set_outputs : array 1 .. * of real, iterations : int)
        var output : array 1 .. INPUT_SET_COUNT of real
        var error : array 1 .. INPUT_SET_COUNT of real
        var delta : array 1 .. INPUT_SET_COUNT of real
        var adjustments : array 1 .. INPUT_PARAM_COUNT of real

        for iteration : 1 .. iterations
            % Calculate output and error (1st step)
            output := think_func (set_inputs)
            vect_subn (set_outputs, output)
            for vect_ind : 1 .. INPUT_SET_COUNT
                output (vect_ind) := sigmoid_der (output (vect_ind))
                error (vect_ind) := vector_fx (vect_ind)
            end for

            % Calculate error (2nd step)
            vect_mult (error, output)
            for vect_ind : 1 .. INPUT_SET_COUNT
                delta (vect_ind) := vector_fx (vect_ind)
            end for

            % Calculate delta
            dot_prod (set_inputs, delta, true)
            for vect_ind : 1 .. INPUT_PARAM_COUNT
                adjustments (vect_ind) := vector_fx (vect_ind)
            end for

            % Calculate adjustments
            vect_addn (synaptic_weights, adjustments)
            for vect_ind : 1 .. INPUT_PARAM_COUNT
                synaptic_weights (vect_ind) := vector_fx (vect_ind)
            end for
        end for

    end train

    % Procedure: displays the values of the network's weights
    procedure disp_weights
        put "{ " ..
        for input_num : 1 .. INPUT_PARAM_COUNT
            put synaptic_weights (input_num) ..
            put " " ..
        end for
        put "}"
    end disp_weights

    % Procedure: prints an output based on the input data set
    procedure think_proc (input : array 1 .. INPUT_PARAM_COUNT of real)
        var input_matx : array 1 .. 1, 1 .. INPUT_PARAM_COUNT of real
        for input_indx : 1 .. INPUT_PARAM_COUNT
            input_matx (1, input_indx) := input (input_indx)
        end for
        dot_prod (input_matx, synaptic_weights, false)
        put sigmoid (vector_fx (1))
    end think_proc

end NeuralNetwork

% Function: returns the format string
function get_format (param_str : string) : string
    var out_string : string := ""
    for ind : 1 .. length (param_str)
        if param_str (ind) = " " then
            out_string := out_string + " "
        else
            out_string := out_string + "&"
        end if
    end for
    result out_string
end get_format

% Function: extracts a substring from a spaced-out string with an index
function ind_spaced_str (param_str : string, param_ind : int) : string
    var test_str : string

    % Base case
    if param_ind = 0 then
        var next_space := length (param_str)
        if index (param_str, " ") > 1 then
            next_space := index (param_str, " ") - 1
        end if
        result param_str (1 .. next_space)
    end if

    % Recursive case
    test_str := ind_spaced_str (param_str (index (param_str, " ") + 1 .. *), param_ind - 1)
    if test_str = param_str then
        result ""
    else
        result test_str
    end if
end ind_spaced_str

% Function: before program execution, test if the set and parameter counts of I/O are matching
function test_set_input : boolean
    var in_string : string
    var stream_in_num, in_row_count, out_row_count, in_param : int := 0

    % Analyze FILE_NAME_SET_I for errors
    open : stream_in_num, FILE_NAME_SET_I, get
    loop
        exit when eof (stream_in_num)
        get : stream_in_num, in_string : *
        for ind : 1 .. length (in_string)
            if not (in_string (ind) = " " or strintok (in_string (ind))) then
                put "An error has occurred in Line ", in_row_count + 1, " in \"", FILE_NAME_SET_I, "\": illegal character detected; only spaces and digits are valid characters"
                result false
            end if
        end for
        in_row_count := in_row_count + 1
    end loop
    close : stream_in_num

    % Analyze FILE_NAME_SET_O for errors
    open : stream_in_num, FILE_NAME_SET_O, get
    loop
        exit when eof (stream_in_num)
        get : stream_in_num, in_string : *
        for ind : 1 .. length (in_string)
            if not (in_string (ind) = " " or strintok (in_string (ind))) then
                put "An error has occurred in Line ", out_row_count + 1, " in \"", FILE_NAME_SET_O, "\": illegal character detected; only spaces and digits are valid characters"
                result false
            end if
        end for
        out_row_count := out_row_count + 1
    end loop
    close : stream_in_num

    if in_row_count not= out_row_count then
        put "An error has occurred: maximum Line counts are not similar for \"", FILE_NAME_SET_I, "\" and \"", FILE_NAME_SET_O, "\""
        result false
    end if

    % Result to true if no errors are found in the set I/O files
    result true
end test_set_input

% Function: extracts the set inputs from a .txt file
function get_set_inputs : array 1 .. INPUT_SET_COUNT, 1 .. INPUT_PARAM_COUNT of real
    var file_input : array 1 .. INPUT_SET_COUNT, 1 .. INPUT_PARAM_COUNT of real
    var in_string : string
    var stream_in_num, line_count, row_count : int := 0

    open : stream_in_num, FILE_NAME_SET_I, get
    loop
        exit when eof (stream_in_num)
        get : stream_in_num, in_string
        file_input (row_count + 1, line_count mod INPUT_PARAM_COUNT + 1) := strreal (in_string)
        line_count := line_count + 1
        if line_count mod INPUT_PARAM_COUNT = 0 then
            line_count := 0
            row_count := row_count + 1
        end if
    end loop
    close : stream_in_num

    result file_input
end get_set_inputs

% Function: extracts the set outputs from a .txt file
function get_set_outputs : array 1 .. INPUT_SET_COUNT of real
    var file_input : array 1 .. INPUT_SET_COUNT of real
    var in_string : string
    var stream_in_num, line_count : int := 0

    open : stream_in_num, FILE_NAME_SET_O, get
    loop
        exit when eof (stream_in_num)
        get : stream_in_num, in_string
        file_input (line_count + 1) := strreal (in_string)
        line_count := line_count + 1
    end loop
    close : stream_in_num

    result file_input
end get_set_outputs

% Procedure: displays the set inputs and outputs
procedure disp_set_io (set_inputs : array 1 .. *, 1 .. * of real, set_outputs : array 1 .. * of real)
    put " NEURAL NETWORK IN TURING"
    put ""
    put " LIST OF: SET_INPUT (SET_OUTPUT)\n"
    for set_index : 1 .. upper (set_outputs)
        put " " : 10 ..
        if (set_index <= 10) then
            for index_in_set : 1 .. upper (set_inputs, 2)
                put set_inputs (set_index, index_in_set), " " ..
            end for
            put "(", set_outputs (set_index), ")"
        else
            put "..."
            exit
        end if
    end for
end disp_set_io

% Procedure: captures user input and uses the neural network to process it, which loops infinitely
procedure input_loop (p : pointer to NeuralNetwork)
    var test_set : array 1 .. INPUT_PARAM_COUNT of real
    var test_str : string
    var output_ok : boolean

    put ""
    loop
        output_ok := true
        put " INPUT:  " ..
        get test_str : *
        for ind : 1 .. INPUT_PARAM_COUNT
            if strrealok (ind_spaced_str (test_str, ind - 1)) then
                test_set (ind) := strreal (ind_spaced_str (test_str, ind - 1))
            else
                put "\n Error: an invalid character was typed; please try again.\n"
                output_ok := false
                exit
            end if
        end for

        if output_ok then
            put " OUTPUT: " ..
            p -> think_proc (test_set)
            put ""
        end if
    end loop
end input_loop

% Procedure: test via main-line logic
procedure main
    Rand.Reset

    var p : pointer to NeuralNetwork
    var set_inputs : array 1 .. INPUT_SET_COUNT, 1 .. INPUT_PARAM_COUNT of real
    var set_outputs : array 1 .. INPUT_SET_COUNT of real

    set_inputs := get_set_inputs
    set_outputs := get_set_outputs
    disp_set_io (set_inputs, set_outputs)

    new NeuralNetwork, p
    p -> train (set_inputs, set_outputs, 10 ** 4)
    input_loop (p)
end main

% Run the main-line logic, if the input test returned OK
if test_set_input then
    main
end if
