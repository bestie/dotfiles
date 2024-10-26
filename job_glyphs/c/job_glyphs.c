#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_JOB_LINE_LENGTH 100
#define MAX_APP_NAME_LENGTH 20
#define MAX_GLYPH_LENGTH 10
#define DEFAULT_GLYPH "⚙"
#define DEFAULT_SEPARATOR "\n"

typedef struct {
  char name[MAX_APP_NAME_LENGTH];
  char glyph[MAX_GLYPH_LENGTH];
} App;

const char *get_glyph_by_job_name(const char *job_name, App *list, int list_size) {
  for (int i = 0; i < list_size; ++i) {
    if (strcmp(job_name, list[i].name) == 0) {
      return list[i].glyph;
    }
  }
  return DEFAULT_GLYPH;
}

int main(int argc, char *argv[]) {
  App app_list[] = {
      {"vim", ""},     {"nvim", ""},       {"vi", ""},
      {"bash", ""},    {"fish", "󰈺"},      {"less", "󰅮"},
      {"tmux", ""},    {"java", ""},       {"lua", ""},
      {"node", ""},

      {"rails", ""},   {"rake", "󱕄"},      {"bundle", ""},
      {"gem", ""},     {"cargo", ""},

      {"clang", ""},   {"clangd", ""},     {"gcc", ""},
      {"g++", ""},

      {"git", ""},     {"make", ""},       {"docker", ""},

      {"mysql", ""},   {"postgres", ""},   {"redis", ""},
      {"sqlite3", ""}, {"kafka", "󱀏"},

      {"bash", ""},    {"c", ""},          {"c#", ""},
      {"c++", ""},     {"clojure", ""},    {"clojurescript", ""},
      {"dart", ""},    {"elixir", ""},     {"erlang", ""},
      {"fish", ""},    {"go", ""},         {"haskell", ""},
      {"java", ""},    {"javascript", ""}, {"julia", ""},
      {"lua", ""},     {"node", ""},       {"ocaml", "λ"},
      {"php", ""},     {"python", ""},     {"ruby", ""},
      {"rust", ""},    {"scala", ""},      {"sh", ""},
      {"swift", ""},   {"typescript", ""}, {"vim", ""},
      {"zsh", ""},

      {"emacs", ""},
  };
  int list_length = sizeof(app_list) / sizeof(App);
  char job_line[MAX_JOB_LINE_LENGTH];
  char separator[16] = DEFAULT_SEPARATOR;

  if (argc > 1) {
    strcpy(separator, argv[1]);
  }

  while (fgets(job_line, MAX_JOB_LINE_LENGTH, stdin)) {
    char *job_name = strtok(job_line, " \n");
    const char *glyph = NULL;

    if (job_name != NULL) {
      glyph = get_glyph_by_job_name(job_name, app_list, list_length);

      printf("%s%s", glyph, separator);
    }
  }

  return 0;
}
