import pyqb

print pyqb.CLEAR

for i in range(1, 11):
    for j in range(1, 11):
        print pyqb.at(j, i * 3), i * j

