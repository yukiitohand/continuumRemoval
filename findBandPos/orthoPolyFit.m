function [cont,bases] = orthoPolyFit(x,S,order,varargin)
% [cont,polybases] = orthoPolyFit(x,S,order,options)
%   Calculate a convex/non-convex continuum curve for a give spectrum with  
%   a specified number of polynomial bases. Supported polynomial bases are
%   Hermite polynomials, cosine polynomials, Legendre polynomials, and the
%   augmented Fourier polynomials. See [1] and [2] for detail.
%   +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%   Input variables
%     x: dx1 1d-array, wavelength samples, monotonically increasing.
%     S: dxN 2d-array of reflectance matrix. Each column represents
%        reflectance spectra associated with wavelength samples.  
%     order: integer, number of polynomial bases used for continuum curve
%            fitting. Smaller, simpler and larger, more complex the curve
%            will be.
%     options: currently not implemented. It will be used for selecting
%     types of basis functions, such as 
%   Optional Parameters
%     'BASES': can be strings like{'Hermite',} or [d x *] array
%             (default) 'Hermite'
%   Output variables
%     cont: continuum dxN array
%     bases: [d x *] array, each column is a basis vector for continua.
%   +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%   REFERENCES
%      [1] M. Craig, “Nonconvex hulls for mineral reflectance spectra.,” 
%          Appl. Opt., vol. 33, no. 5, pp. 849–56, 1994.
%      [2] M. Parente, H. D. Makarewicz, and J. L. Bishop, “Decomposition 
%          of mineral absorption bands using nonlinear least squares curve 
%          fitting: Application to Martian meteorites and CRISM data,” 
%          Planet. Space Sci., vol. 59, no. 5–6, pp. 423–442, 2011.

d = length(x);
[d,N] = size(S);
bases = 'Hermite';
P=zeros(d,order);

if (rem(length(varargin),2)==1)
    error('Optional parameters should always go by pairs.');
else
    for i=1:2:(length(varargin)-1)
        switch upper(varargin{i})
            case 'BASES'
                bases = varargin{i+1};
            otherwise
                % Hmmm, something wrong with the parameter string
                error(['Unrecognized option: ''' varargin{i} '''']);
        end;
    end;
end



% scale wavelength samples within the range [0 1]
% it is assumed that wavelength samples are monotonically increasing.
min_x = x(1); max_x = x(end);
x_scaled = (x-min_x)/(max_x-min_x);
x_scaled(1) = 0; x_scaled(end) = 1;

% currently only Hermite Polynomial is only supported.
if ischar(bases)
    if strcmpi(bases,'Hermite')
        for i=1:order
            P(:,i)=polyval(HermitePoly(i-1),x_scaled); 
            % each column is a hermite pol calculated in x
        end
    end
elseif isnumeric(bases)
    if size(bases,1) == d
        P = bases(:,1:order);
    else
        error('size of bases is not correct.')
    end
else
    error('the bases is not supported');
end

f=sum(P,1); % f is the sum over x (the area) of each standard
cont=zeros(d,N);
for k=1:size(S,2)
    % solve linear programming 
    % min_u  f'u
    % subject to -P'u <= -s
    s = S(:,k);
    cvx_begin quiet
        variable u(order)
        minimize f*u
        subject to
            P*u >= s
    cvx_end
    
%     [u,lambda,exitflag,output] = linprog(f,-P,-S(:,k),[],[],[],[],0,options);

%     if (exitflag<0) 
%         fprintf('exit flag = %d \n',exitflag)
%     end

    y=P*u; % fit model

    %figure
    %subplot(1,2,1)
    %plot(x,S(:,k),'b',x,y,'r')
    %subplot(1,2,2)
    %plot(x(180:end),S(180:end,k)./y(180:end))
    
    cont(:,k) = y(:);
end

bases = P;

end
