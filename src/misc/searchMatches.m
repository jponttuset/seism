function [matches,numMatches] = searchMatches(db1,set1, db2,set2)

set1_names = db_ids(db1, set1);
set2_names = db_ids(db2, set2);

[matches, numMatches] = matchSets(set1_names,set2_names);

if numMatches==0,
    display('Sets do not overlap!');
else
    display(['there are ' num2str(numMatches) ' matches between ' db1 ' ' set1 ' and ' db2 ' ' set2 '!!']);
end



end

function [matches, numMatches] = matchSets(set1_names,set2_names)
% Check if two sets overlap

matches = [];
numMatches = 0;

for ii=1:length(set1_names),
    if ismember(set1_names{ii},set2_names),
        numMatches = numMatches + 1;
        matches{numMatches} = set1_names{ii};
    end
end
end