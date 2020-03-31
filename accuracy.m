function acc = accuracy(X)
acc = (X(1,1)+X(2,2))/sum(X,'all');
end