#!/bin/sh

# THIS IMPLEMENTATION DOESN'T HANDLE ARGUMENTS CORRECTLY. Hence v0.0.0, rather
# than v1.0.0.

# Escape according to POSIX Standard requirements.
# 
# No arguments or a single '-' as argument make escape read from stdin.
# Otherwise the positional arguments will be escaped.

# The POSIX Standard's specification for quoting on the shell states, that the
# following characters must be escaped.
#
#    |  &  ;  <  >  (  )  $  `  \  "  '  *  ?  [  #  ˜ =  %
#    <space>  <tab>  <newline> 
# 
# These are punctuation and whitespace characters.
#
# The [:punct:] characters are:
#
#    ! " # $ % & ' ( ) * + , - . / : ; < = > ? @ [ \ ] ^ _ ` { | } ~
#
# The [:space:] characters are:
#
#    <space>, <tab>, <newline>, <carriage return>, <line feed>, <vertical tab>
#
# The characters to escape include both " and ', which makes it difficult to
# conveniently write a regex pattern matching them both in an invocation of
# sed. With double quoting and escape quoting you have to escape all the above
# characters manually, with single quoting you can't include the '.
#
# Instead we write a negated bracket expression, that matches against any
# character except the alphanumeric characters, the control characters, and the
# punctuation characters that shouldn't be escaped:
#
#    [^][:cntrl:][:alnum:]/!+,-.:@^_{]
#      ^
#      |
#    In the first position after ^ the ] loses its special meaning within
#    bracket expressions.
#
# This bracket expression includes the /, which is commonly used as separator
# in sed. To avoid ambiguity we may use any other character except \ and
# <newline> as delimiter.
# To illustrate here are examles of delimiter use:
#
#    's|\([^][:cntrl:][:alnum:]/!+,-.:@^_{]\)|\\\1|g'
#    's#\([^][:cntrl:][:alnum:]/!+,-.:@^_{]\)#\\\1#g'
#    's;\([^][:cntrl:][:alnum:]/!+,-.:@^_{]\);\\\1;g'
#    's \([^][:cntrl:][:alnum:]/!+,-.:@^_{]\) \\\1 g'
#
# (Yes! You can even use the space as delimiter, though of course then you
# can't use it in the patterns anymore!)

sub='s#\([^][:cntrl:][:alnum:]/!+,-.:@^_{]\)#\\\1#g'

# Read from stdin if no args or only -
if [ $# -eq 0 -o $# -eq 1 -a "$1" = "-" ]; then
   sed "$sub"

# Escape arguments
else
   output="$(echo "$1" | sed "$sub")"
   shift

   for parameter; do
      output="$outs $(echo "$parameter" | sed "$sub")"
   done

   printf '%s' "$output"
fi
