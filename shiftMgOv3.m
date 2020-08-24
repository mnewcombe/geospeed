function difference = shiftMgOv3(radius)
global datashift

shiftdistradial = (datashift(:,1) - radius);   %subtract radius from all distances and convert to mm
radialdatashift = [shiftdistradial datashift(:,2)];

% reflect this matrix about the origin and fit both the original matrix and the
% reflected matrix with a cubic spline

original = radialdatashift;
reflected = [-radialdatashift(:,1) radialdatashift(:,2)];

comparisondist_pos = 0.01:0.01:max(original(:,1));
comparisondist_neg = - comparisondist_pos;
comparisondist = [comparisondist_neg 0 comparisondist_pos];

yy = spline(original(:,1), original(:,2), comparisondist);
zz = spline(reflected(:,1), reflected(:,2), comparisondist);

difference = sum((yy - zz).^2)
radius
end