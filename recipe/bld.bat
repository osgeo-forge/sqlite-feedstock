if "%ARCH%"=="32" (
set PLATFORM=x86
) else (
set PLATFORM=x64
)

:: See: https://sqlite.org/howtocompile.html

:: Already enabled in Makifile.msc, by default for Win build
:: -DSQLITE_ENABLE_FTS3=1
:: -DSQLITE_ENABLE_RTREE=1
:: -DSQLITE_ENABLE_GEOPOLY=1
:: -DSQLITE_ENABLE_JSON1=1
:: -DSQLITE_ENABLE_STMTVTAB=1
:: -DSQLITE_ENABLE_DBPAGE_VTAB=1
:: -DSQLITE_ENABLE_DBSTAT_VTAB=1
:: -DSQLITE_INTROSPECTION_PRAGMAS=1
:: -DSQLITE_ENABLE_DESERIALIZE=1
:: -DSQLITE_ENABLE_COLUMN_METADATA=1

:: Add other opts set in OSGeo4W build
set "opts=-DSQLITE_ENABLE_FTS3_PARENTHESIS=1 -DSQLITE_ENABLE_STAT3=1 -DSQLITE_ENABLE_UPDATE_DELETE_LIMIT=1 -D_CRT_SECURE_NO_WARNINGS=1"

:: Note: running 'clean' target first,
nmake /f Makefile.msc "OPTS=%opts%" clean
if %errorlevel% neq 0 echo Failed to make clean & exit /b 1

:: Dump version to rc file
:: (though only created in autoconf Makefile.msc, apparently referenced in build of root Makefile.msc)
echo VERSION = ^#define SQLITE_VERSION "%PKG_VERSION%"  1>>rcver.vc
if %errorlevel% neq 0 echo Failed to write version to rcver.vc & exit /b 1

:: Note: make all requires TCL; we only need dll and shell
nmake /f Makefile.msc "OPTS=%opts%" core install
if %errorlevel% neq 0 echo Failed to make core install & exit /b 1

echo Copying sqlite3 artifacts to prefix
copy sqlite3.exe %LIBRARY_BIN% || exit 1
copy sqlite3.dll %LIBRARY_BIN% || exit 1
copy sqlite3.lib %LIBRARY_LIB% || exit 1
copy sqlite3.h   %LIBRARY_INC% || exit 1
