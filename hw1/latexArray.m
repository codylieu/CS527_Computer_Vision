function latex(A, matrixname, filename, format)

[rows, cols] = size(A);

fp = fopen(filename, 'w');

fprintf(fp, '%s = \\left[\\begin{array}{*{%d}c}\n', matrixname, cols);
for i = 1:rows
    fprintf(fp, '\t');
    for j = 1:cols
        if A(i, j)
            fprintf(fp, format, A(i, j));
        end
        if j < cols
            fprintf(fp, ' & ');
        elseif i < rows
            fprintf(fp, '\\\\\n');
        else
            fprintf(fp, '\n');
        end
    end
end
fprintf(fp, '\\end{array}\\right]\n');

fclose(fp);