# Using readlines()
file1 = open('103.txt', 'r')
Lines = file1.readlines()
  
with open(r'103stripped.txt', 'w') as fp:
        
    # Strips the newline character
    for line in Lines:
        line = line.strip("•")
        line = line.strip()
    
        fp.write("%s\n" % line)

print('Done')