# Delphi-ZlibEx
Fork of Brent Sherwood's ZlibEx to support a recent zlib ( https://www.zlib.net/ ) version.

Original code can be found on https://www.base2ti.com/

This version has been adapted to work with ZLib 1.2.11
Most of the differences arise from new safety checks added to ZLib starting from 1.2.9 onwards. One of them does not allow moving/copying of certain structures in the memory.

Object files were built with BCC 5.5 
CFLAGS = -c -O2 -Ve -X -pr -a8 -b -d -k- -vi -tWM -u- $(LOC)

Delphi 5 was used to compile the code. So only 32-bit support is expected.

