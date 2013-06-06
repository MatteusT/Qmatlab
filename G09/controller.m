classdef controller < handle
    properties
        dataPath
        template
        paramNames
        inname
        iterations
        outputs
    end
    methods
        function obj = controller(datapath, template, params)
            obj.dataPath = datapath;
            obj.template = template;
            obj.paramNames = cell(1,size(params,2));
            temp = cell(1,size(params,2));
            for i=1:size(params,2)
                obj.paramNames{1,i} = params{i}{1};
                temp{1,i} = num2cell(params{i}{2});
                if length(params{i}) > 2
                    obj.inname(i) = params{i}{3};
                else
                    obj.inname(i) = 0;
                end
            end
            
            if length(temp) ~= 0
                obj.iterations = obj.cartesianProduct(temp);
                for i=1:length(obj.iterations)
                    obj.outputs{i} = gaussian(obj, obj.iterations{i});
                end
            else
               obj.outputs{1} = gaussian(obj, {});
            end
        end

        function out = cartesianProduct(obj, remaining, varargin)
            % in = {{{a}, {b}}, {{c}, {d}}}
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
                obj.outputs{i}.runGaussian();
            end
        end
    end
end