function [ Cnt ] = ConcaveHullFit( x,S )
% [ Cnt ] = ConcaveHullFit(x,S)
%   compute concave hulls of the spectrum S
%   Input variables
%     x: dx1 1d-array, wavelength samples, monotonically increasing.
%     S: dxN 2d-array of reflectance matrix. Each column represents
%        reflectance spectra associated with wavelength samples.  
%
%
x = x(:);
d = length(x);
[d,N] = size(S);

Cnt = zeros(d,N);

% % implementaion with linear programming
% L = zeros([d,d]);
% for i=2:d-1
%     L(i,i) = -1;
%     L(i,i-1) = (x(i+1)-x(i)) / (x(i+1)-x(i-1));
%     L(i,i+1) = (x(i)-x(i-1)) / (x(i+1)-x(i-1));
% end
% L = L(2:end-1,:);
% 
% for n=1:N
%     s = S(:,n);
%     cvx_begin
%         variable cnt(d)
%         minimize sum(cnt)
%         subject to
%             cnt >= s
%             L*cnt <= 0
%     cvx_end
%     
%     Cnt(:,n) = cnt;
%     
% end

% based on the algorithm CONVEXHULL(P) 
% Mark de Berg, Otfried Cheong, Marc van Kreveld, and Mark Overmars,
% Computational Geometry: Algorithm and Applications, pp. 6-7 in Chapter 1

for n=1:N
    s = S(:,n);
    xcnt = x(1:2); y = s(1:2);
    for i=3:d
        xcnt = [xcnt;x(i)]; y = [y;s(i)];
        flg = 1;
        while flg == 1
            a1 = (y(end-1)-y(end-2)) / (xcnt(end-1)-xcnt(end-2));
            a2 = (y(end)-y(end-1)) / (xcnt(end)-xcnt(end-1));
            if a2>a1
                xcnt(end-1) = xcnt(end); xcnt = xcnt(1:end-1);
                y(end-1) = y(end); y = y(1:end-1);
                flg = (length(xcnt)>2);
            else
                flg=0;
            end
        end
    end
    cnt = interp1(xcnt,y,x);
    Cnt(:,n) = cnt;
    
end


end

