Qmatlab
=======
A library for running and parsing Gaussian output from Matlab.

Automating Gaussian
-------------------
All of the automation of running Gaussian is facilitated by the controller class.

    controller(PATH_TO_TEMPLATE, TEMPLATE_NAME_WITHOUT_EXTENSION, PARAMETERS)

Upon initialization the controller class creates all of the gaussian objects that will be iterated over. The objects are not run through Gaussian at this time to allow for just parsing files.

All of the gaussian objects are stored in the `controller.outputs` cell array.


Templates
---------

Template files are just normal Gaussian input files with variable parameters in the file. The parameters can be any property within the file and can be any name so long as nothing else in the file contains that name other than the parameter that is being swapped out.

Here is an example template for Hydrogen with two possible parameters to swap out (METHOD and BASIS).

    %chk=temp.chk
    # METHOD/BASIS

    title

    0 1
     H
     H                  1            B1

       B1             0.60000000



Parameters
----------

Parameters take the form of an N by 3 cell array. The first cell is the name of the parameter in the template file. The second cell is a cell array of possible values to fill the parameter with. The final cell is a boolean value of weather or not the parameter gets added to the final name.

    {                                                           ...
        {'PARAMETER_NAME', {P1, P2, ..., PN},  PART_OF_NAME},   ...
        {'PARAMETER_NAME2', {P1, P2, ..., PN}, PART_OF_NAME},   ...
    }

A basic example of a parameter set is as follows:

    {                               ...
        {'METHOD', {'mp2'},  1},    ...
        {'BASIS', {'6-21G'}, 1},    ...
    };

When applied to the template mentioned above this will create/run a single hydrogen molecule with the method `mp2`, the basis `6-21G` and a final filename of `h2_mp2_6-21G`.

This example can easily be expanded to include many more basis sets or methods.

    {                                               ...
        {'METHOD', {'mp2', 'B3LYP'},  1},           ...
        {'BASIS', {'6-21G', 'STO-3G', '6-31G'}, 1}, ...
    };

This will create/run 6 hydrogen molecules with the basis sets/methods.

    {'mp2' '6-21G'}
    {'mp2' 'STO-3G'}
    {'mp2' '6-31G'}
    {'B3LYP' '6-21G'}
    {'B3LYP' 'STO-3G'}
    {'B3LYP' '6-31G'}

Now, if there was another parameter that was added to the template file, say `BONDLEN`.

    {                                               ...
        {'METHOD', {'mp2', 'B3LYP'},  1},           ...
        {'BASIS', {'6-21G', 'STO-3G', '6-31G'}, 1}, ...
        {'BONDLEN', [.2:.1:2], 1},                  ...
    };

This would create/run 114 (2\*3\*19) hydrogen molecules with all of the combinations of those parameters.

    {'mp2' '6-21G', .2}
    {'mp2' '6-21G', .3}
    ...
    {'B3LYP' '6-31G', 1.8}
    {'B3LYP' '6-31G', 2}

