filename = '{filename}'

with open(filename, 'r') as f:
    lines = f.read().splitlines()

for line in lines:
    print(line)
