#include <stdlib.h>
#include <stdio.h>
#include <string.h>

int main(int argc, char** argv) {

   /* Which separator to use? */

   int delim = '\n';
   if(argc == 2 && !strcmp("-0", argv[1])) delim = '\0';

   /* Setup random source from /dev/urandom */

   FILE *random_source;
   random_source = fopen("/dev/urandom", "r");
   if(random_source == NULL) { perror("Couldn't access /dev/urandom/\n"); exit(1); }

   srandom(getc(random_source));

   fclose(random_source);

   /* Read all the lines */

   // Initial guess at the number of lines
   size_t size_guess = 100;
   size_t size_step = 100;

   // Allocate buffer to hold the pointers to the lines
   // (needs to be heap, cause will use memcpy on it)
   char** lines = calloc(size_guess, sizeof(char*));
   if(lines == NULL) { perror("Failure to allocate for the lines\n"); exit(1); }

   size_t lines_count = 0;
   size_t line_capacity;

   while(1) {

      // Read a new line
      lines[lines_count] = NULL;
      if(getdelim(&lines[lines_count], &line_capacity, delim, stdin) < 0) break;

      // Number of input lines exceeds current allocation
      if(++lines_count == size_guess) {

	 // Allocate larger lines pointer buffer
	 size_t new_guess = size_guess + (size_step += 25);
	 char** new_lines = calloc(new_guess, sizeof(char*));
	 if(new_lines == NULL) {
	    perror("Failure to re-allocate for the lines\n");
	    exit(1);
	 }

	 // Transfer already read lines
	 memcpy(new_lines, lines, size_guess*sizeof(char*));

	 // Make the new buffer be the main buffer
	 free(lines);
	 lines = new_lines;
	 size_guess = new_guess;

      }
   }

   /* Fisher-Yates shuffle */

   for(size_t i = 0; i < lines_count-2; i++) {

      // i <= j < n
      size_t j = random() % (lines_count-i) + i;

      // Swap lines[i] and lines[j]
      char* x = lines[i];
      lines[i] = lines[j];
      lines[j] = x;

   }

   /* Output results */

   for(size_t i=0; i < lines_count; i++) {
      printf("%s", lines[i]);

      // printf expects NUL-delimited strings and won't include NUL as delimiter
      if(delim == '\0') printf("%c", '\0');
   }

   /* Deallocations */

   for(size_t i=0; i < lines_count; i++) free(lines[i]);
   free(lines);

   return 0;
}
