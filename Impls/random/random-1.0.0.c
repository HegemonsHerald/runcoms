#include <stdlib.h>
#include <stdio.h>

int main(int argc, char* argv[]) {
   // Setup pseudo random number sequence
   FILE *random_source;
   random_source = fopen("/dev/urandom", "r");
   int seed = getc(random_source);
   fclose(random_source);
   srandom(seed);

   // Get number of digits
   int digits;
   if (argc == 1) digits = 10;
   else sscanf(argv[1], "%d", &digits);

   // Print a non-0 digit to start the integer
   long d = random() % 10;
   while (d == 0) { d = random() % 10; }
   printf("%ld", d);

   // Print as many further digits as necessary
   for(int i = 1; i < digits; i++)
      printf("%ld", random() % 10);

   printf("\n");
   return 0;
}
