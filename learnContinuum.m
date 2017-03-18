function [ continua,bases ] = learnContinuum( wv,S,cntType,varargin )
% [ continua,bases ] = learnContinuum( wv,S,cntType,varargin )
%   learn continuum of spectra
%     Input Variables
%        wv: [d x 1] array, wavelengths, monotonically increasing
%        S : [d x N] array of spectral signals, each column corresponds to 
%            one spectral signals.
%        cntType: type of the continuum {'convhull','baseprojection'}
%     Optional Parameters
%        order: integer, 
%               order of the polynomials used in 'polybases' option.
%               number of retained bases in 'convhull'
%               (default) 7
%        projection: boolean, only valid in 'convhull', controlling if the
%                   returned 'continua' is projected on the subspace or not.
%                   (default) false
%        bases: string like 'Hermite' 
%               or[d x *] array, bases of the continua of spectral signals
%                necessary for cntType {'baseprojection'}
%     Output parameters
%        continua: [d x N] array of continua of the spectra
%        bases: only used 
%
%   Usage
%      [ continua,bases ] = learnContinuum( wv,S,'convhull')
%      [ continua,bases ] = learnContinuum( wv,S,'convhull',...
%                       'projection',true,'order',7)
%      [ continua,bases ] = learnContinuum( wv,S,'baseprojection',...
%                       'order',7,'bases','Hermite')

order = 7;
projection = false;
bases = 'Hermite';

if (rem(length(varargin),2)==1)
    error('Optional parameters should always go by pairs.');
else
    for i=1:2:(length(varargin)-1)
        switch upper(varargin{i})
            case 'ORDER'
                order = varargin{i+1};
%                 if (~isinteger(order))
%                        error('ORDER must be a positive integer.');
%                 end
            case 'PROJECTION'
                projection = varargin{i+1};
                if strcmp(cntType,'polybases')
                       warning('PROJECTION is not used.');
                end
            case 'BASES'
                bases = varargin{i+1};
            otherwise
                % Hmmm, something wrong with the parameter string
                error(['Unrecognized option: ''' varargin{i} '''']);
        end;
    end;
end

switch lower(cntType)
    case 'convhull'
        % Upper Concave hull approaximation
        continua = ConcaveHullFit(wv,S);
        % SVD on concave hull continuum
        [bases,Scv,Vcv] = svds(continua,order);
        if projection
            continua = bases*Scv*Vcv';
        end
    case 'baseprojection'
        % basis projection
        [continua,bases] = orthoPolyFit(wv,S,order,'BASES',bases);
    otherwise
        fprintf('cntType %s is not supported.\n',cntType);
end



end

