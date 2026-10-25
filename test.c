// file: test.c
// vim:fileencoding=utf-8:ft=c:tabstop=2
// This is free and unencumbered software released into the public domain.
//
// Author: R.F. Smith <rsmith@xs4all.nl>
// SPDX-License-Identifier: Unlicense
// Created: 2026-04-08 00:05:11 +0200
// Last modified: 2026-10-25T21:02:11+0100

#include "logging.c"

#define BOLD_WHITE "\033[1;37m"
#define CYAN "\033[0;36m"
#define GREEN "\033[0;32m"
#define BOLD_GREEN "\033[1;32m"
#define PURPLE "\033[0;35m"
#define BOLD_RED "\033[1;31m"
#define RED "\033[0;31m"
#define YELLOW "\033[0;33m"
#define BOLD_YELLOW "\033[1;33m"
#define RESET "\033[0m"  // No Color

#ifndef VERSION
#define VERSION "UNKNOWN"
#endif


int main(__attribute__((unused)) int argc, __attribute__((unused)) char *argv[])
{
  puts(BOLD_RED"Built from test.c and arena.c, version "VERSION""RESET);
  logging_configure("logging test", LOG_DEBUG);
  debug("this is a test of a debug message");
  info("this is a test of an info message");
  warning("this is a test of a warning message");
  error("this is a test of an error message");
  return 0;
}
