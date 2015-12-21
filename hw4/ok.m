function answer = ok(net)

assert(isvector(net), 'The net is either empty or is not a vector of layers')

field = {'kernel', 'bias', 'stride', 'h'};

L = length(net);

for l = 1:L
    layer = net(l);
    
    % Check that all required fields exist
    for f = 1:length(field)
        assert(isfield(layer, field{f}), ...
            'Layer %d does not have field ''%s''', l, field{f});
    end
    
    % Check kernel dimensions
    assert(ndims(layer.kernel) <= 3, ...
        'Kernel in layer %d has more than 3 dimensions', l);
    if l == 1
        assert(size(layer.kernel, 2) == 1, ...
            'Second dimension of the kernel in layer 1 is not 1');
    else
        assert(size(layer.kernel, 2) == size(net(l-1).kernel, 3), ...
            ['Second dimension of the kernel in layer %d', ...
            '\nis not equal to the third dimension', ...
            ' of the kernel in layer %d'], ...
            l, l-1);
    end
    if l == L
        assert(size(layer.kernel, 3) == 1, ...
            'Third dimension of the kernel in the last layer is not 1');
    end
    
    % Check bias dimensions
    assert(isrow(layer.bias), ...
        'The bias in layer %d is not a row vector', l);
    assert(length(layer.bias) == size(layer.kernel, 3), ...
        ['The number of entries of the bias vector in layer %d', ...
        '\nis not equal to the number of kernels', ...
        '\n(i.e., to the third dimension of the kernel in layer %d)'], ...
        l, l);
    
    % Check stride
    assert(isscalar(layer.stride), ...
        'The stride in layer %d is not a scalar', l);
    assert(round(layer.stride) == layer.stride, ...
        'The stride in layer %d is not an integer', l);
    assert(layer.stride > 0, ...
        'The stride in layer %d is not positive', l);
    
    % Check activation function
    assert(isa(layer.h, 'function_handle'), ...
        'The activation function in layer %d is not a function handle', l);
    try
        [~, ~] = layer.h(rand(5, 7));
    catch matlabError
        assert(false, ['Calling the activation function in layer %d', ...
            '\nwith argument rand(5, 7) and two output arguments', ...
            '\nwould result in the following Matlab error message:\n', ...
            matlabError.message], l);
    end
end

answer = true;

end