import os

col_name_file=open("tmp_column_names.txt")
out_file=open("tmp_subject_order.txt", "w")

line=col_name_file.readline()
elements=line.strip().split()

for i in range(9, len(elements)):
    iid=elements[i].split("_")[0]
    out_file.write(iid + " " + iid + "\n")

col_name_file.close()
out_file.close()
