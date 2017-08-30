import sys

header="""
\\begin{table}[h]
\\centering
{\\small
\\begin{tabular}{|p{0.18\\linewidth}|p{0.2\\linewidth}|p{0.5\\linewidth}|}
\\hline"""

footer="""
\\end{tabular}
}
\\caption{}
\\label{}
\\end{table}"""

# read data
data={}
theme=None
category=None
with open(sys.argv[1]) as f:
    lines = f.readlines()
    
for line in lines:
    line = line.rstrip().split('    ')
    level = len(line)-1
    if level == 1:
        theme = line[-1]
        data[theme] = {}
    elif level == 2:
        category = line[-1]
        data[theme][category] = []
    elif level == 3:
        data[theme][category].append(line[-1])

# print table
print(header)
for theme in data.keys():
    categories = list(data[theme].keys())
    print("\\multirow{{{}}}{{*}}{{{}}}".format(len(categories), theme))
    for i in range(len(categories)):
        category = categories[i]
        print(" & {} & {}".format(category, data[theme][category][0]), end='')
        for code in data[theme][category][1:]:
            print(", {}".format(code), end='')
        if i==len(categories)-1:
            print(" \\\\ \\hline")
        else:
            print(" \\\\ \\cline{2-3}")
print(footer)
