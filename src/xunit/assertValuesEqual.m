function assertValuesEqual(A, B)
%assertValuesEqual
% Assert array elements are of equal value, that is, ignoring
% the type and the orientation of the vector.

if ~(isvector(A) && isvector(B))
    message = xunit.utils.comparisonMessage('', ...
        'Both input must be vectors.', ...
        A, B);
    throwAsCaller(MException('assertElementsEqual:notVectors', ...
        '%s', message));
end

if numel(A)~=numel(B)
    message = xunit.utils.comparisonMessage('', ...
        'Vectors of different length.', ...
        A, B);
    throwAsCaller(MException('assertElementsEqual:differentLength', ...
        '%s', message));
end

for ii=1:numel(A)
    if A(ii)~=B(ii)    
       message = xunit.utils.comparisonMessage('', 'Input elements are not all equal.', ...
            A, B);    
       throwAsCaller(MException('assertElementsAlmostEqual:tolExceeded', ...
            '%s', message));
    end
end
