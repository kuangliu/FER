function dX_relu = max_pool_backward(X_relu, X_pool, dX_pool, pool_param)
    [H, W, C, N] = size(X_pool);
    pool_h = pool_param.height;
    pool_w = pool_param.weight;

    dX_relu = zeros(size(X_relu));

    for i = 1:W
        for j = 1:H
            % map out index to in index
            x = i + (i-1)*(pool_w-1);
            y = j + (j-1)*(pool_h-1);

            cube = X_relu(y:y+pool_h-1, x:x+pool_w-1, :, :);
            max_val = X_pool(j, i, :, :);

            mask = bsxfun(@eq, cube, max_val);
            
            % TODO: for several same max value, how to backprop the gradient?
            % #1: equally distribute the gradient
            % #2: randomly choose one
            % which is reasonable?

            %scale = sum(reshape(mask, [], 1, C, N), 1);
            scale = 1;

            t = bsxfun(@times, mask, dX_pool(j, i, :, :));
            dX_relu(y:y+pool_h-1, x:x+pool_w-1, :, :) = bsxfun(@rdivide, t, scale);
        end
    end

end

% function mask = max_pool_backward(X_relu, X_pool, pool_param)
%     [H, W, ~, ~] = size(X_pool);
%     pool_h = pool_param.height;
%     pool_w = pool_param.weight;
%     
%     dX_relu = zeros(size(X_relu));
%     for i = 1:W
%         for j = 1:H
%             % map out index to in index
%             x = i + (i-1)*(pool_w-1);
%             y = j + (j-1)*(pool_h-1);
%             
%             cube = X_relu(y:y+pool_h-1, x:x+pool_w-1, :, :);
%             max_val = X_pool(j, i, :, :);
%             mask = bsxfun(@eq, cube, max_val)
%         end
%     end
% 
% end