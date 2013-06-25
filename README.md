Qmatlab
=======
A library for running and parsing Gaussian output from Matlab.

Automation API
--------------
All of the specifc programs that are automated inherit from the `Base` class. This class defines the common API.

The `Base` class has a minimal implementation with just three properties and two methods. Each subclass from this should implement both of these methods.

    Base
        properties
            dataPath % the path in which the template resides
            template % the name of the template without a file extension
            params   % a struct with parameter names and their corresponding values to replace them with.
            filename % the name of the file with all the parameters added to it without any file extensions or path
        end
        methods
            Base(dataPath, template, params) % creates the Base object
            run(obj) % handles all of the running of the respective program
            parse(obj) % takes the output from run and parses it
        end

As a minimum, a new program can be added based on the following template.

    classdef Name < Base
        properties
            % some parsed properties
        end
        methods
            function obj = Name(dataPath, template, params)
               obj = obj@Base(dataPath, template, params);
               % anything else for the constructor
            end
            function run(obj)
                % what it needs run
                obj.parse()
            end
            function parse(obj)
                % some parsing code
            end
        end
    end

Automating a Program
--------------------
All of the automation of running any program is facilitated by the `Controller` class.

    Controller(PATH_TO_TEMPLATE, TEMPLATE_NAME_WITHOUT_EXTENSION, PARAMETERS, @PROGRAM_CLASS_NAME)

Upon initialization the Controller class creates all of the class objects that will be iterated over. The objects are not run through the program at this time to allow for just parsing files. To then run all of the files one just uses `Controller.runAll()`. This calls the `run()` method of all of the objects created in the initalization step.

All of the objects are stored in the `Controller.outputs` cell array.

So, for example, this would run the template `h2` at `some/path` through Gaussian. After running the calculation, the energey of the molecule is extracted.

    c = Controller('some/path', 'h2', {}, @Gaussian);
    c.runAll();
    e = c.ouputs{1}.Ehf;

Templates
---------

Template files are just normal input files with variable parameters in the file. The parameters can be any property within the file and can be any name so long as nothing else in the file contains that name other than the parameter that is being swapped out.

Here is an example Gaussian template for Hydrogen with two possible parameters to swap out (METHOD and BASIS).

    %chk=temp.chk
    # METHOD/BASIS

    title

    0 1
     H
     H                  1            B1

       B1             0.60000000



Parameters
----------

Parameters take the form of a struct where the struct field names are the parameter names to be replaced. Each field has a cell array inside of it with two values. 1) the possible replacement values and 2) and a boolean value of whether or not that parameter gets added to the name of the job. The part in name is optional, if a value is not given, `false` will be assumed.

    params.PARAM1 = {{P1, P2, ..., PN},  PART_OF_NAME};
    params.PARAM2 = {{P1, P2, ..., PN},  PART_OF_NAME};

A basic example of a parameter set is as follows:

    params.METHOD = {{'mp2'}, 1};
    params.BASIS = {{'6-21G'}, 1};

When applied to the template mentioned above this will create/run a single hydrogen molecule with the method `mp2`, the basis `6-21G` and a final filename of `h2_mp2_6-21G`.

This example can easily be expanded to include many more basis sets or methods.

    params.METHOD = {{'mp2', 'B3LYP'}, 1};
    params.BASIS = {{'6-21G', 'STO-3G', '6-31G'}, 1};

This will create/run 6 hydrogen molecules with the basis sets/methods.

    {'mp2' '6-21G'}
    {'mp2' 'STO-3G'}
    {'mp2' '6-31G'}
    {'B3LYP' '6-21G'}
    {'B3LYP' 'STO-3G'}
    {'B3LYP' '6-31G'}

Now, if there was another parameter that was added to the template file, say `BONDLEN`.

    params.METHOD = {{'mp2', 'B3LYP'}, 1};
    params.BASIS = {{'STO-3G', '6-21G', '6-31G'}, 1};
    params.BONDLEN = {[.5:.1:2.5], 1};

This would create/run 114 (2\*3\*19) hydrogen molecules with all of the combinations of those parameters.

    {'mp2' '6-21G', .2}
    {'mp2' '6-21G', .3}
    ...
    {'B3LYP' '6-31G', 1.8}
    {'B3LYP' '6-31G', 2}


Notes
-----

There is a problem with the difference in the way that Gaussian and Matlab interpret types, so if you are making using a parameter that uses integers it might not work.

The change from cell arrays to structs was to better accommodate the workflow for INDO. This change also allows for a simpler access to specific parameter names.
