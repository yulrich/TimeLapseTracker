function [Candidates]= tagPairsGeodistFilt(tagblob,anttagblob,Candidates,antBW,maxdist,mindist)

for i=1:size(tagblob.centroid,1)
    
    j=find(Candidates(:,i)>0);
    
    for c=j'
        
        for k=1:size(anttagblob.centroid,1)
            
            if  ~isempty(intersect(anttagblob.linindxpixlist{k},tagblob.linindxpixlist{i}))
                
                croppedIm=imcrop(antBW,anttagblob.bbox(k,:));
                %  croppedI=imcrop(I,anttagblob.bbox(k,:));
                box_corner=[anttagblob.bbox(k,1) anttagblob.bbox(k,2)];
                %    centri=round(tagblob.centroid(i,:)-double(box_corner));
                %    centrc=round(tagblob.centroid(c,:)-double(box_corner));
                
                % x,y coordinates of all pixels in blob i
                [tagiX,tagiY]=ind2sub(size(antBW),tagblob.linindxpixlist{i});
                tagiX= max(round(tagiX-double(box_corner(2))),0);
                tagiY= max(round(tagiY-double(box_corner(1))),0);
                
                badInd=find(tagiX==0 | tagiY==0);
                
                tagiX(badInd)=[];
                tagiY(badInd)=[];
                
                if ~ isempty(tagiX)
                    
                    Geodist=bwdistgeodesic(logical(croppedIm),tagiY,tagiX,'quasi-euclidean');
                   
                    % x,y coordinates of all pixels in blob c
                    [tagcX,tagcY]=ind2sub(size(antBW),tagblob.linindxpixlist{c});
                    tagcX= max(round(tagcX-double(box_corner(2))),0);
                    tagcY= max(round(tagcY-double(box_corner(1))),0);
                    
                    badInd=find(tagcX==0 | tagcY==0);
                    
                    tagcX(badInd)=[];
                    tagcY(badInd)=[];
              
                    DistFlag=0;
                    
                   
                    for cPix=1:size(tagcX,1)
%                         disp (Geodist(tagcX(cPix),tagcY(cPix)))
                        % if there is a pixel in tag c that is close
                        % enough, match
                        if Geodist(tagcX(cPix),tagcY(cPix)) < maxdist 
                            DistFlag=1;
                        end
                    end
                    
                    for cPix=1:size(tagcX,1)
                        % if there is a pixel that is too close, unmatch
                        if Geodist(tagcX(cPix),tagcY(cPix)) < mindist 
                            DistFlag=0;
                        end
                    end
                    
                    
                    if DistFlag == 0
                        
                        Candidates(c,i)=0;
                    end
                    
                end
            end
            
        end
        
    end
    
end