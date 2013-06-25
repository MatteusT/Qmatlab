classdef Controller < handle
    properties
        dataPath    % The path to the directory that contains the template
        template    % The name of the template file without the path/file ext
        paramNames  % A cell array of all the parameters and replacement values
        inname      % A semi-temporary cell array that stores bool values of whether or not a value is added to the name
        iterations  % A cell array with a listing of all the parameter combinations
        outputs     % A cell array with all the program instances
        program     % A pointer to the program/class to use
    end
    methods
        function obj = Controller(datapath, template, params, program)
            obj.dataPath = datapath;
            obj.template = template;
            obj.paramNames = cell(1,size(params,2));
            obj.program = program;

            % separate the paramNames, params, and inname values
            temp = cell(1,size(params,2));
            obj.paramNames = fieldnames(params);
            for i=1:size(obj.paramNames)
                x = obj.paramNames{i};
                temp{1,i} = num2cell(params.(x){1});
                if length(params.(x)) > 1
                    obj.inname(i) = params.(x){2};
                else
                    obj.inname(i) = 0;
                end
            end

            if length(temp) ~= 0
                obj.iterations = obj.cartesianProduct(temp);
                % go through all the iterations and pair the parameters
                % with their respective paramName to then feed to the
                % program
                for i=1:length(obj.iterations)
                    for j=1:length(obj.paramNames)
                        x = obj.paramNames{j};
                        tparam.(x){1} = obj.iterations{i}{j};
                        tparam.(x){2} = obj.inname(j);
                    end
                    obj.outputs{i} = obj.program(obj.dataPath, obj.template, tparam);
                end
            else
               obj.outputs{1} = obj.program(obj, {});
            end
        end

        function out = cartesianProduct(obj, remaining, varargin)
            % This method does a simple cartesian product of a cell array
            % that is used as input.
            % cartesianProduct({{{a}, {b}}, {{c}, {d}}})
            % out = {{a, c}, {a, d}, {b, c}, {b, d}}
            out = {};
            if length(varargin) == 0
                out = remaining{1,1};
            else
                for i=1:size(varargin{1}, 2)
                    for j=1:size(remaining{1}, 2)
                        out{1,end+1} = [varargin{1}{i} remaining{1}{j}];
                    end
                end
            end
            if size(remaining, 2) >= 2
                out = obj.cartesianProduct({remaining{1,2:end}}, out);
            end
        end

        function runAll(obj)
            for i=1:size(obj.outputs, 2)
                obj.outputs{i}.run();
            end
        end
    end
end