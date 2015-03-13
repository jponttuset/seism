function test_suite = test_matlab_multiarray
%test_matlab_multiarray Test suite for matlab_multiarray
initTestSuite;

function test_types
input = rand(100,200)*50;
[output1, output2, output3, output4, output5, output6, ...
 output7, output8, output9, output10, output11] =...
mex_test_matlab_multiarray(input, logical(input), single(input),...
                         int8(input),uint8(input),int16(input),uint16(input),...
                         int32(input),uint32(input),int64(input),uint64(input));
        
% Check types
assertTrue(isa(output1, 'double'));
assertTrue(isa(output2, 'logical'));
assertTrue(isa(output3, 'single'));
assertTrue(isa(output4, 'int8'));
assertTrue(isa(output5, 'uint8'));
assertTrue(isa(output6, 'int16'));
assertTrue(isa(output7, 'uint16'));
assertTrue(isa(output8, 'int32'));
assertTrue(isa(output9, 'uint32'));
assertTrue(isa(output10, 'int64'));
assertTrue(isa(output11, 'uint64'));

% Check dimensions
assertEqual(size(output1),[100 200]);
assertEqual(size(output2),[100 200]);
assertEqual(size(output3),[100 200]);
assertEqual(size(output4),[100 200]);
assertEqual(size(output5),[100 200]);
assertEqual(size(output6),[100 200]);
assertEqual(size(output7),[100 200]);
assertEqual(size(output8),[100 200]);
assertEqual(size(output9),[100 200]);
assertEqual(size(output10),[100 200]);
assertEqual(size(output11),[100 200]);

