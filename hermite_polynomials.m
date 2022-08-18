
function [bases] = hermite_polynomials(x,order)


% scale wavelength samples within the range [0 1]
% it is assumed that wavelength samples are monotonically increasing.
min_x = x(1); max_x = x(end);
x_scaled = (x-min_x)/(max_x-min_x)*2;
x_scaled(1) = 0; x_scaled(end) = 2;
x_scaled = x_scaled-1;
bases = zeros(length(x),order);
for i=1:order
    bases(:,i)=polyval(HermitePoly(i-1),x_scaled); 
    % each column is a hermite pol calculated in x
end

end