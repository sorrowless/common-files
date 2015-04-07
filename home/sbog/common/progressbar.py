import sys
import time


for i in range(101):
    print('\rPrepare ... [%d%%]' % i, end='')
    time.sleep(0.005)
print('\n')

import random
random.seed()

num20min = random.randint(1,10) * 10000
num20max = num20min + 9999
num21min = num20min + random.randint(1,10) * 1000
num21max = num21min + 999
num22min = num21min + random.randint(1,10) * 100
num22max = num22min + 99
num23min = num22min + random.randint(1,10) * 10
num23max = num23min + 9
num4 = random.randint(1,10)
mass = [ [10000,99999],
         [num20min,num20max],
         [num21min,num21max],
         [num22min,num22max],
         [num23min,num23max]
       ]

for i in range(5):
    for a in range(101):
        print('\rTrying to solve ... [%d]' % random.randint(mass[i][0], mass[i][1]), end='')
        time.sleep(0.01)

print('\n')

cons = ['.    ','..   ','...  ','.... ','.....',' ....','  ...','   ..','    .']
num = 0
for i in range(30):
    print('\rCleaning up %s' % cons[num], end='')
    if num<len(cons)-1:
        num += 1
    else:
        num = 0
    time.sleep(0.3)
print()
