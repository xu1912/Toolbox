#!/usr/bin/python

import fileinput, os, string, sys, re, warnings, shutil, pprint

def main():
        fn = sys.argv[1]

        rs = open(fn,'r')
        lines = rs.readlines()
        sn=fn.split(".")[0]
        out1 = open(sn+"_db.txt",'w')
        out2 = open(sn+"_plate.txt",'w')
        n=0
        pn=1
        cn=0
        a = [["" for x in range(12)] for y in range(8)]
        b = ["a", "b", "c", "d", "e", "f", "g", "h"]
        for line in lines:
                data=line.strip()

                n += 1

                rn= n % 8

                if rn <> 0:
                        print(str(rn)+"_"+str(cn))
                        a[rn-1][cn]=data
                        out1.write(data+"\t"+str(pn)+"\t"+b[rn-1]+str(cn+1)+"\n")
                else:
                        rn = 8
                        print(str(rn)+"_"+str(cn))
                        a[rn-1][cn]=data
                        out1.write(data+"\t"+str(pn)+"\t"+b[rn-1]+str(cn+1)+"\n")
                        cn = cn + 1


                if n== 96:
                        n=0
                        cn=0
                        out2.write("Plate"+str(pn)+"\n")
                        for row in a:
                                for item in row:
                                        out2.write(item+"\t")

                                out2.write("\n")
                        out2.write("\n\n")
                        a = [["" for x in range(12)] for y in range(8)]
                        pn += 1

        if n > 0:
                out2.write("Plate"+str(pn)+"\n")
                for row in a:
                        for item in row:
                                out2.write(item+"\t")

                        out2.write("\n")


        rs.close()
        out1.close()
        out2.close()


if __name__ == "__main__":
        main()
