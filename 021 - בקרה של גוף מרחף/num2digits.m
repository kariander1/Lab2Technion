 function out = num2digits(s)
 C = num2cell(num2str(s));
 out = double([C{:}])-48;