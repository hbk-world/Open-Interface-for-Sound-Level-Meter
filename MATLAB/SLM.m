classdef SLM
    % SLM object which stores the ip of the 2245 and stores some help functions
    % such as starting/stoping a measurement and the common REST protocols
    properties
        ip
        host
        putOptn
        postOptn
    end
    
    methods
        
        function obj = SLM(val)
            if nargin > 0
                obj.ip = val;
                obj.host = "http://" + obj.ip;
                
                % Sets the right options for webwrite (PUT & POST)
                obj.putOptn = weboptions('MediaType','application/json','RequestMethod', 'put');
                obj.postOptn = weboptions('MediaType','application/json','RequestMethod', 'post');
            end
        end
        
        % HTTP PUT
        function result = put(obj, path, value)
            result =  webwrite(obj.host + path, value, obj.putOptn);
        end
        
        % HTTP POST
        function result = post(obj, path, value)
            result = webwrite(obj.host + path, value, obj.postOptn);
        end
        
        % HTTP GET
        function result = get(obj, path)
            result = webread(obj.host + path);
        end
        
        
        % This function starts or pause a measurement.
        function start_puase_measurement(obj, start)
            response = obj.get("/webxi/Applications/SLM/State");
            
            if(start && response ~= "Running")
                obj.put("/WebXi/Applications/SLM?Action=StartPause","");
                
            elseif( ~start && response == "Running")
                obj.put("/WebXi/Applications/SLM?Action=StartPause","");
            end
            
        end
        
        %Stop the measurement on the device
        function stop_measurent(obj)
            
            obj.put("/WebXi/Applications/SLM?Action=Stop","");
        end
        
    end
end