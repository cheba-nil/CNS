function y = sinc_interpVec(x,u)
% sinc interpolation function, the input can be a data vector or matrix,
% the number of rows is assumed to be the number of data dimension, the
% number of columns is assumed to be the time points. The interpolation is
% applied column wise.
% Ze Wang @ 6-09-2004 Upenn
[dim,len]=size(x);
[dim2,ulen]=size(u);
if dim2==1
    u=repmat(u,dim,1);
else
    if dim2~=dim disp('We can'' figure out what you want to do\n');return; end;
end
m = 0:len-1;
m=repmat(m,[dim,1]);
for i=1:ulen
    weight=sinc(m- repmat(u(:,i),1,len));
    swei=sum(weight,2);
    if abs(swei(1)-1)>0.1
        weight=weight./repmat(swei,1,len);
    end
  
  y(:,i) = sum(x.*weight, 2);
end
