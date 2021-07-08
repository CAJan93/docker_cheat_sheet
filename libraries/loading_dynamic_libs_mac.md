- [1. Loading Dynamic Libraries on Mac](#1-loading-dynamic-libraries-on-mac)
  - [1.1. How dynamic libraries work](#11-how-dynamic-libraries-work)
  - [1.2. How dynamic libraries are located](#12-how-dynamic-libraries-are-located)
  - [1.3. Viewing dependencies](#13-viewing-dependencies)
  - [1.4. How dynamic library paths are chosen](#14-how-dynamic-library-paths-are-chosen)
  - [1.5. How dynamic libraries choose IDs](#15-how-dynamic-libraries-choose-ids)
  - [1.6. Special keywords for library IDs](#16-special-keywords-for-library-ids)
  - [1.7. Changing dynamic library IDs](#17-changing-dynamic-library-ids)
  - [1.8. Changing Loader Paths](#18-changing-loader-paths)
  - [1.9. Trouble shooting](#19-trouble-shooting)

# 1. Loading Dynamic Libraries on Mac

From [this blog post](http://clarkkromenaker.com/post/library-dynamic-loading-mac/).

## 1.1. How dynamic libraries work

- Possibilities to consume someone elses code:
  - Download their code and compile it together with yours
  - Use a **static library** which is included in your executable/lib at compile time
  - Use a **dynamic library** which is referenced by your executable/lib when it runs

- Option 1 and 2 result in a bigger executable/lib
- Dynamic libs use `.ddl` on windows, `.dylib` on mac and `.so` on linux
- Dynamic libs are loaded at binary startup. You get the error `image not found` if they are missing


## 1.2. How dynamic libraries are located

- The location of the dynamic lib is **embedded in the executable/lib**


## 1.3. Viewing dependencies 

- Use `otool -l EXE_OR_LIB_PATH` to view dependencies
  - See the `LC_LOAD_DYLIB` keywords
- Some paths may include the keyword `@rpath`
- Paths may be relative or absolute
  - Relative paths are unsafe, since a user can run a binary from anywhere

```txt
          cmd   LC_LOAD_DYLIB
      cmdsize   48
         name   /usr/lib/libc++.1.dylib (offset 24)
   time stamp   2 Wed Dec 31 16:00:02 1969
      current   version 902.1.0
compatibility   version 1.0.0
 Load command   13
```

## 1.4. How dynamic library paths are chosen 

- Executable/lib **gets the path from the dynamic lib**
- Use `otool -l <LIB>` to view `LC_ID_DYLIB` command


```txt
 Load command   4
          cmd   LC_ID_DYLIB
      cmdsize   48
         name   out/bin/libavutil.dylib (offset 24)
   time stamp   1 Wed Dec 31 16:00:01 1969
      current   version 58.111.101
compatibility   version 58.0.0
```

## 1.5. How dynamic libraries choose IDs

- `LC_ID_DYLIB` is chosen when the dependent library is built
- Default location is `/usr/local`
- In Xcode you specify using `Dynamic Library Install Name` build setting

## 1.6. Special keywords for library IDs

- Goal: specify `LC_ID_DYLIB` such that binary will always look in its own dir for dylibs
- We can use neither absolute path for it not relative paths.
  - First one assumes fixed folder structure of computer
  - Second assumes from where binary is called
- Use e.g. `@executable_path/LIB_NAME.dylib` to get the binary path at runtime for `LC_ID_DYLIB`
- Use e.g. `@loader_path/InternalLib/libinternal.dylib` when loading `libinterla.dylib` from `libcool.dylib`
- Loader: The binary or library that loads the dylib

```txt
executable
/CoolLib
    libcool.dylib
    /InternalLib
        libinternal.dylib
```

-  `@rpath` is used to specify a list of paths that the executable/lib searches for the dylib. List of paths stored in executable
   -  The binary/lib specifies paths in `LC_RPATH`
  

## 1.7. Changing dynamic library IDs

- Use `install_name_tool -id NEW_ID LIB_PATH` to change the `LC_ID_DYLIB` of a library

## 1.8. Changing Loader Paths

- use `install_name_tool -change OLD_PATH NEW_PATH LIB_PATH` to change the `LC_LOAD_DYLIB` fields

## 1.9. Trouble shooting 

- Use `DYLD_PRINT_LIBRARIES=1 ./myexecutable` to get output about the libs that are being loaded on startup 