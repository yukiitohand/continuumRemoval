function [ Scntrmvd ] = CntRmvl( S,method,varargin )
% [ Scntrmvd ] = CntRmvl( S,method,varargin )
%   Perform continuum removal
%     Input Variables
%        S : [d x N] array of spectral signals, each column corresponds to 
%            one spectral signals.
%        method: {'additive','multiplicative','projective'}
%     Optional Parameters
%      ++ NOTE ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%      Depending on method, necessary parameters are different. Be careful.
%      ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%      continua: [d x N] array, continua of the spectral signals
%                necessary for methods {'additive','multiplicative'}
%      bases: [d x *] array, bases of the continua of spectral signals
%                necessary for method {'projective'}
%   Usage
%     [ Scntrmvd ] = CntRmvl( S,'multiplicative','CONTINUA',continua);
%     [ Scntrmvd ] = CntRmvl( S,'bases','BASES',bases);
%


if (rem(length(varargin),2)==1)
    error('Optional parameters should always go by pairs.');
else
    for i=1:2:(length(varargin)-1)
        switch upper(varargin{i})
            case 'BASES'
                bases = varargin{i+1};
                if strcmp(method,'additive') || strcmp(method,'multiplicative')
                       warning(sprintf('bases is not necessary of %s.',method));
                end
            case 'CONTINUA'
                continua = varargin{i+1};
                if strcmp(method,'projective')
                       warning(sprintf('bases is not necessary of %s.',method));
                end
            otherwise
                % Hmmm, something wrong with the parameter string
                error(['Unrecognized option: ''' varargin{i} '''']);
        end;
    end;
end

switch lower(method)
    case 'additive'
        Scntrmvd = continua-S;
    case 'multiplicative'
        Scntrmvd = 1 - S ./ continua;
    case 'projective'
        I = eye(size(S,1));
        Scntrmvd = (I-bases*pinv(bases))*S;
    otherwise
        fprintf('cntType %s is not supported.\n',method);
end




end

