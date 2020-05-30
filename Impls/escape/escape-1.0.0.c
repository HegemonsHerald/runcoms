#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <string.h>

// Helper to write to stdout. Argument must be a variable symbol!
#define WRITE(c)\
   if(fwrite(&c, sizeof(char), 1, stdout) == 0) {\
      perror("Couldn't write to stdout\n"); exit(1);\
   }

// Write the escaped version of the character to stdout
void escape(char c) {

   char esc_char = '\\';
   int esc = 0;

   switch(c) {
      case '|'  : esc = 1; break;
      case '&'  : esc = 1; break;
      case ';'  : esc = 1; break;
      case '<'  : esc = 1; break;
      case '>'  : esc = 1; break;
      case '('  : esc = 1; break;
      case ')'  : esc = 1; break;
      case '$'  : esc = 1; break;
      case '`'  : esc = 1; break;
      case '\\' : esc = 1; break;
      case '"'  : esc = 1; break;
      case '\'' : esc = 1; break;
      case '*'  : esc = 1; break;
      case '?'  : esc = 1; break;
      case '['  : esc = 1; break;
      case '#'  : esc = 1; break;
      case '~'  : esc = 1; break;
      case '='  : esc = 1; break;
      case '%'  : esc = 1; break;
      case ' '  : esc = 1; break;
      case  9   : esc = 1; break; // tab
      case 10   : esc = 1; break; // newline
   }

   if(esc) WRITE(esc_char);
   WRITE(c);

}

int main(int argc, char** argv) {

   // Argument Mode
   // Escape arguments if there is only one argument and it isn't the -0 flag or
   // there are multiple arguments
   if((argc == 2 && strcmp(argv[1], "-0") != 0) || argc > 2) {

      // For each argument escape each character
      for(int i=1; i < argc; i++) {

         for(int j=0; argv[i][j] != '\0'; j++)
            escape(argv[i][j]);

         // Output unescaped spaces in between the escaped words
         char space = ' ';
         if(i != argc-1) WRITE(space);
      }

      return 0;

   }


   // Stdin Mode

   int delim = '\n';

   // Null byte mode?
   if(argc == 2 && strcmp(argv[1], "-0") == 0) delim = '\0';

   char c;
   while((c = getc(stdin)) != EOF) {

      // Do not escape the delimiter
      if(c == delim) {
         WRITE(c);
         continue;
      }

      // Escape any other character
      escape(c);

   }

   return 0;

}
