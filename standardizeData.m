function outArray = standardizeData(inArray,column)

[row,col]=size(inArray);

temp=zeros(row,col);
for i=1:col
    if nargin==2
        if(i~=column)
            temp(:,i)=inArray(:,i);
            continue;
        end
    end
    
    mean_std=[mean(inArray(:,i)) std(inArray(:,i))];
    for j=1:row
        temp(j,i)=(inArray(j,i)-mean_std(1))/mean_std(2);
    end
end

outArray=temp;