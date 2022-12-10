#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int num_cycles = 0;
int *part1_values = NULL;

char
**tokens(char *in_str)
{
  char **res = malloc(sizeof(char*) * 2);
  int num_token = 1;
  char delim_count[2];
  delim_count[0] = ' ';
  delim_count[1] = 0;
  char delim_newline[2];
  delim_newline[0] = '\n';
  delim_newline[1] = 0;

  res[0] = strtok(in_str, delim_count);

  in_str = strtok(0, delim_count);
  char* num = strtok(in_str, delim_newline);
  if (num == NULL) {
    res[0] = strtok(res[0], delim_newline);
    res[1] = "0";
  } else {
    res[1] = num;
  }
  return res;
}

void
part1_parse(char **tokens)
{
  int increase = atoi(tokens[1]);
  int cycles = 0;
  if (strcmp(tokens[0], "addx")) {
    cycles = 1;
  } else if (strcmp(tokens[0], "noop")) {
    cycles = 2;
  } else {
    cycles = 0;
  }
  int i;
  for(i = 0; i < cycles; i++) {
    num_cycles++;
    part1_values = realloc(part1_values, sizeof(int)*(2+num_cycles));
    part1_values[num_cycles] = part1_values[num_cycles-1];
  }
  part1_values[num_cycles] = part1_values[num_cycles] + increase;
}

int
main(void)
{
  FILE *fp;
  char *line = NULL;
  size_t len = 0;
  ssize_t read;

  part1_values = calloc(2,sizeof(int));
  num_cycles = 1;
  part1_values[0] = 1;
  part1_values[1] = 1;

  fp = fopen("./resources/input", "r");
  if (fp == NULL)
    exit(EXIT_FAILURE);

  while ((read = getline(&line, &len, fp)) != -1) {
    char** token = tokens(line);
    part1_parse(token);
  }

  int cycles[6] = {20, 60, 100, 140, 180, 220};
  int sum = 0;
  for (int i = 0; i < 6; i++) {
    sum += part1_values[cycles[i]] * (cycles[i]);
  }

  printf("Part 1: %d\n" , sum);
  printf("\nPart 2: \n");
  for (int i = 0; i < 240; i++) {
    char draw = '.';
    int index = i % 40;
    int position = part1_values[i+1];
    if (position == index || position == index-1 || position == index+1) {
      draw = '#';
    }
    printf("%c", draw);
    if (index == 39 && i != 0) {
      printf("\n");
    }
  }
  printf("\n");
  free(line);
  exit(EXIT_SUCCESS);
}
