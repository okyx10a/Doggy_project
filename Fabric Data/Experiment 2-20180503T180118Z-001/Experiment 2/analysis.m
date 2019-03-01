db2b = Z_b2b_u-Z_b2b_l;
db2bInt = Z_b2b_Int_u-Z_b2b_Int_l;
df2b = Z_f2b_u-Z_f2b_l;
df2bInt = Z_f2b_Int_u-Z_f2b_Int_l;
df2f = Z_f2f_u-Z_f2f_l;
df2fInt = Z_f2f_Int_u-Z_f2f_Int_l;
abs(mean([db2b db2bInt df2b df2bInt df2f df2fInt]))
result = sort(abs(mean([db2b db2bInt df2b df2bInt df2f df2fInt])))