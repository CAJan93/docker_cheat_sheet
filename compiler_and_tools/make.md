# Makefiles

## Purpose

Tell make how to compile and link things

## Rule anatomy

``` 
Target … : dependencies …
	Command
	…
```

## Targets

Usually a binary that should be created, or an action (e.g. clean). Targets that do not create a file are called phony (e.g. clean)

## Goal 
The rule that is the most important one (e.g. creating a new binary). You put this rule first

## Variables 
Define and use a variable

```
MyVar = file.cpp otherfile.cpp lastfile.cpp
$(MyVar)    # use 
```