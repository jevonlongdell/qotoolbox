import sys, glob, string

def unix2dos(fmask):
   flist = glob.glob(fmask);
   for fname in flist:
      fp = open(fname,"rb")
      text = fp.read()
      fp.close()
      if string.find(text,'\015') < 0:
         text = string.replace(text,'\012','\015\012')
         fp = open(fname,"wb")
         fp.write(text)
         fp.close()
   

unix2dos("*.m")
unix2dos("ACKNOWLEDGEMENTS")
unix2dos("CHANGELOG")
unix2dos("Copying")
unix2dos("bin/*.bat")
unix2dos("private/*.m")
unix2dos("@eseries/*.m")
unix2dos("@eseries/private/*.m")
unix2dos("@fseries/*.m")
unix2dos("@fseries/private/*.m")
unix2dos("@qo/*.m")
unix2dos("@qo/private/*.m")
unix2dos("@qobase/*.m")
unix2dos("@qobase/private/*.m")
unix2dos("examples/*.m")
unix2dos("src/solvemc/*.c")
unix2dos("src/solvemc/*.h")
unix2dos("src/solvesde/*.c")
unix2dos("src/solvesde/*.h")
unix2dos("src/stochsim/*.c")
unix2dos("src/stochsim/*.h")
unix2dos("src/mccorr/*.c")
unix2dos("src/mccorr/*.h")
unix2dos("unixsrc/solvemc/*.c")
unix2dos("unixsrc/solvemc/*.h")
unix2dos("unixsrc/solvesde/*.c")
unix2dos("unixsrc/solvesde/*.h")
unix2dos("unixsrc/stochsim/*.c")
unix2dos("unixsrc/stochsim/*.h")
unix2dos("unixsrc/mccorr/*.c")
unix2dos("unixsrc/mccorr/*.h")

