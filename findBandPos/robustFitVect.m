function [map,map23]=robustFitVect(imIn,w,origmap,s1,s2,graphic)


[m,n,p]=size(imIn);


options=optimset('LargeScale','off','Simplex','on','Display','off');

for i=2:m-1
    tic,
    for j=2:n-1
        if rem(i,50)==0 && rem(j,50)==0
            fprintf(strcat('i= ',num2str(i),' j= ',num2str(j),'\n'))
        end
        if origmap(i,j)>0
            c=imIn((i-floor((s1-1)/2)):(i+floor(s1/2)),(j-floor((s2-1)/2))...
                :(j+floor(s2/2)),:);
            
            % good for now : find better outlier control
            %l=squeeze(mean(mean(c,1),2));
            %l2=squeeze(trimmean(trimmean(c,10,1),10,2));
            l2=squeeze(median(median(c,1),2));
            %sm=csaps(w,double(l),0.999999995);
            % for kaolinite
            %sm2=csaps(w,double(l2),0.99999995);
            % for nontronite
            sm2=csaps(w,double(l2),0.999999);
            fit=fnval(w,sm2);
            
            cont=orthoPolyFit(w,fit,3,options);
            bands=fit./cont;
            smNC=csaps(w,bands);
            
            
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % extrema calculation
            z1=fnzeros(fnder(sm2,1));
            % gives the position of all minima and maxima and inflection points
            z=mean(z1);
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % extremal points for continuum-removed spectrum
            
            % initializations
            MinNC=[];
            
            
            zNC=fnzeros(fnder(smNC,1));
            % gives the position of all minima and maxima and inflection points
            zNC=mean(zNC);
            M=fnval(zNC,fnder(smNC,2));
            
            % local minima and maxima
            mins=zNC(M>0);
            smNCvals=fnval(mins,smNC);
            maxs=zNC(M<=0);
             smNCvals2=fnval(maxs,smNC);
            
            % calculate the anchor points to the continuum
%             anchors=[w(1) maxs(smNCvals2>0.9999) w(end)];
%             if length(anchors)>1
%                 anchors=[anchors(diff(anchors)>0.05) anchors(end)];
%             end
%             bIntegr=[];
            %minsBandk=0;
            
            [h2204 band2204idx]=min(abs(mins - 2.204));
            if h2204 < 0.03
                map(i-1,j-1,1)=mins(band2204idx);
                 map(i-1,j-1,2)=mins(band2204idx);
            end
            
            [h2304 band2304idx]=min(abs(mins - 2.304));
            if h2304 < 0.03
                map23(i-1,j-1,1)=mins(band2304idx);
                 map23(i-1,j-1,2)=mins(band2304idx);
            end
            
        end
        
    end
    toc
end

