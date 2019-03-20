{*************************************************************************************************
*  ZLibExApi.pas                                                                                 *
*                                                                                                *
*  copyright (c) 2000-2013 base2 technologies                                                    *
*  copyright (c) 1995-2002 Borland Software Corporation                                          *
*                                                                                                *
*  revision history                                                                              *
*    2013.05.23  updated to zlib version 1.2.8                                                   *
*    2012.05.21  updated for win64 (delphi xe2)                                                  *
*                moved win32 obj files to win32 subfolder                                        *
*                changed win32 obj options to exclude the underscore                             *
*    2012.05.07  updated to zlib version 1.2.7                                                   *
*    2012.03.05  udpated to zlib version 1.2.6                                                   *
*    2010.04.20  updated to zlib version 1.2.5                                                   *
*    2010.04.15  updated to zlib version 1.2.4                                                   *
*    2005.07.25  updated to zlib version 1.2.3                                                   *
*    2005.01.11  updated to zlib version 1.2.2                                                   *
*    2004.01.06  updated to zlib version 1.2.1                                                   *
*    2002.03.15  updated to zlib version 1.1.4                                                   *
*                                                                                                *
*  acknowledgments                                                                               *
*    burak kalayci                                                                               *
*      2002.03.15  informing me about the zlib 1.1.4 update                                      *
*      2004.01.06  informing me about the zlib 1.2.1 update                                      *
*                                                                                                *
*    vicente sanchez-alarcos                                                                     *
*      2005.01.11  informing me about the zlib 1.2.2 update                                      *
*                                                                                                *
*    mathijs van veluw                                                                           *
*      2005.07.25  informing me about the zlib 1.2.3 update                                      *
*                                                                                                *
*    tommi prami                                                                                 *
*      2012.03.05  informing me about the zlib 1.2.6 update                                      *
*                                                                                                *
*    marian pascalau                                                                             *
*      2012.05.21  providing the win64 obj files and your win64 modifications                    *
*                                                                                                *
*    roman ganz                                                                                  *
*      2013.05.23  informing me about the zlib 1.2.8 update                                      *
*************************************************************************************************}

unit ZLibExApi;

interface

{$I ZLibEx.inc}

const
  {** version ids *******************************************************************************}

  ZLIB_VERSION: PAnsiChar = '1.2.11';

  ZLIB_VERNUM = $12b0;

  ZLIB_VER_MAJOR = 1;
  ZLIB_VER_MINOR = 2;
  ZLIB_VER_REVISION = 11;
  ZLIB_VER_SUBREVISION = 0;

  {** compression methods ***********************************************************************}

  Z_DEFLATED = 8;

  {** information flags *************************************************************************}

  Z_INFO_FLAG_SIZE  = $1;
  Z_INFO_FLAG_CRC   = $2;
  Z_INFO_FLAG_ADLER = $4;

  Z_INFO_NONE       = 0;
  Z_INFO_DEFAULT    = Z_INFO_FLAG_SIZE or Z_INFO_FLAG_CRC;

  {** flush constants ***************************************************************************}

  Z_NO_FLUSH      = 0;
  Z_PARTIAL_FLUSH = 1;
  Z_SYNC_FLUSH    = 2;
  Z_FULL_FLUSH    = 3;
  Z_FINISH        = 4;
  Z_BLOCK         = 5;
  Z_TREES         = 6;

  {** return codes ******************************************************************************}

  Z_OK            = 0;
  Z_STREAM_END    = 1;
  Z_NEED_DICT     = 2;
  Z_ERRNO         = (-1);
  Z_STREAM_ERROR  = (-2);
  Z_DATA_ERROR    = (-3);
  Z_MEM_ERROR     = (-4);
  Z_BUF_ERROR     = (-5);
  Z_VERSION_ERROR = (-6);

  {** compression levels ************************************************************************}

  Z_NO_COMPRESSION      =   0;
  Z_BEST_SPEED          =   1;
  Z_BEST_COMPRESSION    =   9;
  Z_DEFAULT_COMPRESSION = (-1);

  {** compression strategies ********************************************************************}

  Z_FILTERED         = 1;
  Z_HUFFMAN_ONLY     = 2;
  Z_RLE              = 3;
  Z_FIXED            = 4;
  Z_DEFAULT_STRATEGY = 0;

  {** data types ********************************************************************************}

  Z_BINARY  = 0;
  Z_TEXT    = 1;
  Z_ASCII   = Z_TEXT;
  Z_UNKNOWN = 2;

  {** return code messages **********************************************************************}

  z_errmsg: Array [0..9] of String = (
    'Need dictionary',      // Z_NEED_DICT      (2)
    'Stream end',           // Z_STREAM_END     (1)
    'OK',                   // Z_OK             (0)
    'File error',           // Z_ERRNO          (-1)
    'Stream error',         // Z_STREAM_ERROR   (-2)
    'Data error',           // Z_DATA_ERROR     (-3)
    'Insufficient memory',  // Z_MEM_ERROR      (-4)
    'Buffer error',         // Z_BUF_ERROR      (-5)
    'Incompatible version', // Z_VERSION_ERROR  (-6)
    ''
  );

type
  TAlloc = function (AppData: Pointer; Items, Size: Integer): Pointer; cdecl;
  TFree = procedure (AppData, Block: Pointer); cdecl;

  PByte = ^Byte;

  PZStreamRec = ^TZStreamRecInt;

  TZInfDefState = packed record
    stream:PZStreamRec;
  end;



  // Internal structure.  Ignore.
  TZStreamRecInt = packed record
    next_in: PChar;       // next input byte
    avail_in: Integer;    // number of bytes available at next_in
    total_in: Longint;    // total nb of input bytes read so far

    next_out: PByte;      // next output byte should be put here
    avail_out: Integer;   // remaining free space at next_out
    total_out: Longint;   // total nb of bytes output so far

    msg: PChar;           // last error message, NULL if no error
    internal: TZInfDefState;    // not visible by applications

    zalloc: TAlloc;       // used to allocate the internal state
    zfree: TFree;         // used to free the internal state
    AppData: Pointer;     // private data object passed to zalloc and zfree

    data_type: Integer;   // best guess about the data type: ascii or binary
    adler: Longint;       // adler32 value of the uncompressed data
    reserved: Longint;    // reserved for future use
  end;

  PZInflateState = ^TZInfDefState;


{** macros **************************************************************************************}

function deflateInit(strm: PZStreamRec; level: Integer): Integer;
  {$ifdef Version2005Plus} inline; {$endif}

function deflateInit2(strm: PZStreamRec; level, method, windowBits,
  memLevel, strategy: Integer): Integer;
  {$ifdef Version2005Plus} inline; {$endif}

function inflateInit(strm: PZStreamRec): Integer;
  {$ifdef Version2005Plus} inline; {$endif}

function inflateInit2(strm: PZStreamRec; windowBits: Integer): Integer;
  {$ifdef Version2005Plus} inline; {$endif}

{** external routines ***************************************************************************}

function deflateInit_(strm: PZStreamRec; level: Integer;
  version: PAnsiChar; recsize: Integer): Integer;

function deflateInit2_(strm: PZStreamRec; level, method, windowBits,
  memLevel, strategy: Integer; version: PAnsiChar; recsize: Integer): Integer;

function deflate(strm: PZStreamRec; flush: Integer): Integer;

function deflateEnd(strm: PZStreamRec): Integer;

function deflateReset(strm: PZStreamRec): Integer;

function inflateInit_(strm: PZStreamRec; version: PAnsiChar;
  recsize: Integer): Integer;

function inflateInit2_(strm: PZStreamRec; windowBits: Integer;
  version: PAnsiChar; recsize: Integer): Integer;

function inflate(strm: PZStreamRec; flush: Integer): Integer;

function inflateEnd(strm: PZStreamRec): Integer;

function inflateReset(strm: PZStreamRec): Integer;

function adler32(adler: Longint; const buf; len: Integer): Longint;

function crc32(crc: Longint; const buf; len: Integer): Longint;

procedure ZStreamInitCheck(strm: PZStreamRec);

implementation

{*************************************************************************************************
*  link zlib code                                                                                *
*                                                                                                *
*  bcc32 flags                                                                                   *
*    -c -O2 -Ve -X -pr -a8 -b -d -k- -vi -tWM -u-                                                *
*                                                                                                *
*  note: do not reorder the following -- doing so will result in external                        *
*  functions being undefined                                                                     *
*************************************************************************************************}

{$L obj\deflate.obj}
{$L obj\inflate.obj}
{$L obj\inftrees.obj}
{$L obj\infback.obj}
{$L obj\inffast.obj}
{$L obj\trees.obj}
{$L obj\compress.obj}
{$L obj\adler32.obj}
{$L obj\crc32.obj}


{** macros **************************************************************************************}

type pcardinal = ^cardinal;

procedure ZStreamInitCheck(strm: PZStreamRec);
begin
 Assert(strm<>nil,'Cannot be null');

 Assert(pcardinal(strm^.internal.stream)^=cardinal(strm),'Should have been inited with link back to stream');

end;


function deflateInit(strm: PZStreamRec; level: Integer): Integer;
begin
  result := deflateInit_(strm, level, ZLIB_VERSION, SizeOf(TZStreamRecInt));
  if result = 0 then ZStreamInitCheck(strm);
end;

function deflateInit2(strm: PZStreamRec; level, method, windowBits,
  memLevel, strategy: Integer): Integer;
begin
  result := deflateInit2_(strm, level, method, windowBits,
    memLevel, strategy, ZLIB_VERSION, SizeOf(TZStreamRecInt));
  if result = 0 then ZStreamInitCheck(strm);
end;

function inflateInit(strm: PZStreamRec): Integer;
begin
  result := inflateInit_(strm, ZLIB_VERSION, SizeOf(TZStreamRecInt));
  if result = 0 then ZStreamInitCheck(strm);
end;

function inflateInit2(strm: PZStreamRec; windowBits: Integer): Integer;
begin
  result := inflateInit2_(strm, windowBits, ZLIB_VERSION,
    SizeOf(TZStreamRecInt));
  if result = 0 then ZStreamInitCheck(strm);
end;

{** external routines ***************************************************************************}

function deflateInit_(strm: PZStreamRec; level: Integer;
  version: PAnsiChar; recsize: Integer): Integer;
  external;

function deflateInit2_(strm: PZStreamRec; level, method, windowBits,
  memLevel, strategy: Integer; version: PAnsiChar; recsize: Integer): Integer;
  external;

function deflate(strm: PZStreamRec; flush: Integer): Integer;
  external;

function deflateEnd(strm: PZStreamRec): Integer;
  external;

function deflateReset(strm: PZStreamRec): Integer;
  external;

function inflateInit_(strm: PZStreamRec; version: PAnsiChar;
  recsize: Integer): Integer;
  external;

function inflateInit2_(strm: PZStreamRec; windowBits: Integer;
  version: PAnsiChar; recsize: Integer): Integer;
  external;

function inflate(strm: PZStreamRec; flush: Integer): Integer;
  external;

function inflateEnd(strm: PZStreamRec): Integer;
  external;

function inflateReset(strm: PZStreamRec): Integer;
  external;

function adler32(adler: Longint; const buf; len: Integer): Longint;
  external;

function crc32(crc: Longint; const buf; len: Integer): Longint;
  external;

{** zlib function implementations ***************************************************************}

function zcalloc(opaque: Pointer; items, size: Integer): Pointer;
begin
  GetMem(result,items * size);
end;

procedure zcfree(opaque, block: Pointer);
begin
  FreeMem(block);
end;

{** c function implementations ******************************************************************}

function memset(p: Pointer; b: Byte; count: Integer): Pointer; cdecl;
begin
  FillChar(p^, count, b);

  result := p;
end;

procedure memcpy(dest, source: Pointer; count: Integer); cdecl;
begin
  Move(source^, dest^, count);
end;

{$ifndef WIN64}
procedure _llmod;
asm
  jmp System.@_llmod;
end;
{$endif}

end.
