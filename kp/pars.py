#       Тимофеев Алексей М8О-207Б-19
import re


def findID(line):
    ID = re.search(r"^0\s+@I(\d+)@\s+INDI$", line)
    if ID is not None:
        return ID.group(1)

def findN(line):
    Name = re.search(r"^1\s+NAME\s+(.+)\s+/(.+)/$", line)
    if Name is not None:
        return Name.group(1) + " " + Name.group(2)

def findS(line):
    Sex = re.search(r"^1\s+SEX\s+([F|M])$", line)
    if Sex is not None:
        return Sex.group(1)

def findHUSB(line):
    HUSB = re.search(r"^1\s+HUSB\s+@I(\d+)@$", line)
    if HUSB is not None:
        return HUSB.group(1)

def findWIFE(line):
    WIFE = re.search(r"^1\s+WIFE\s+@I(\d+)@$", line)
    if WIFE is not None:
        return WIFE.group(1)

def findCHIL(line):
    CHIL = re.search(r"^1\s+CHIL\s+@I(\d+)@$", line)
    if CHIL is not None:
        return CHIL.group(1)
if __name__ == '__main__':
    sp = open("regulations.pl", "a+")
    
    arr = []
    with open("MyProgect1.ged", 'r') as file:
        arr = [row.strip() for row in file]
    
    id1 = list(filter(None, map(findID, arr)))
    name = list(filter(None, map(findN, arr)))
    sex = list(filter(None, map(findS, arr)))
    i=-1
    for s in sex:
        i=i+1
        if s == 'F':
            sp.write("female('{0}').\n".format(name[i]))
        elif s == 'M':
            sp.write("male('{0}').\n".format(name[i]))
    
    with open("MyProgect1.ged", 'r', encoding='utf-8') as file:
        for line in file:
            CHIL=None
            if findHUSB(line):
                HUSB=findHUSB(line)
            if findWIFE(line):
                WIFE=findWIFE(line)
            CHIL=findCHIL(line)
            if CHIL:    
                str2 = "child('{chil}', '{par}')."
                husb1 = name[(id1.index(HUSB))]
                wife1 = name[(id1.index(WIFE))]
                chil1 = name[(id1.index(CHIL))]
                str1 = str2.format(chil=chil1, par=husb1)
                sp.write(str1)
                sp.write('\n')
                str1 = str2.format(chil=chil1, par=wife1)
                sp.write(str1)
                sp.write('\n')
    sp.close()
