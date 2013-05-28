function yy = movMedian(y,span)
%MOVMEDIAN Moving median of y
%   span must be at least 3 consequently y must have a length of at least 3

% check span size
if span < 3
    span = 3;
end

% make sure y is in column form
y = y(:);

l = length(y);
b = zeros(l,span);
% shift y
for i1 = 1:span
    b(:,i1) = circshift(y,i1-1);
end
% find the median of each row
yy = median(b,2);

end

