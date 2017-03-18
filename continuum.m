function [ cnt,xq ] = continuum( y,x,strtIdx,endIdx )
% [ cnt ] = continuum( y,x,strtIdx,endIdx )
%   compute straight-line continuum for x and y over strtIdx:endIdx
xq = x(strtIdx:endIdx);
slp = (y(endIdx)-y(strtIdx)) / (xq(end)-xq(1));
cnt = y(strtIdx) + slp.*(xq-x(strtIdx));

end

