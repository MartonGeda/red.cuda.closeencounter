%% filter the pictures
tic;

d_calculate_trueanomaly;
d_calculate_angleofintersection;

reverse = false;     % if true, renames the files to the original

if (~reverse)
    allen = 'All';

    oldnames = dir(strcat(currentdir,'Test',allen,'\','*.png'));
    oldnames = {oldnames.name};

    % sort the file names, because simple matlab sort function doesn't work!!
    str  = sprintf('%s#', oldnames{:});

    num  = sscanf(str, strcat(allen,'%d.png#'));


    [~, index] = sort(num);
    oldnames = oldnames(index);
    clear index;

    [~,i] = sort(Cf);
    %[~,i] = sort(alpha,'descend');
    oldnames = oldnames(i);

    newnames = cell(1,N);
    for j=1:N
        newnames{j} = strcat(allen,'Adesc',int2str(j),'.png');
    end

    for j=1:N
        java.io.File(fullfile(currentdir,strcat('Test',allen),oldnames{j})).renameTo(java.io.File(fullfile(currentdir,strcat('Test',allen),newnames{j})));
    end

else
    
    for j=1:N
        java.io.File(fullfile(currentdir,strcat('Test',allen),newnames{j})).renameTo(java.io.File(fullfile(currentdir,strcat('Test',allen),oldnames{j})));
    end
end

toc;