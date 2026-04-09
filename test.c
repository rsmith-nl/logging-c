// file: test.c
// vim:fileencoding=utf-8:ft=c:tabstop=2
// This is free and unencumbered software released into the public domain.
//
// Author: R.F. Smith <rsmith@xs4all.nl>
// SPDX-License-Identifier: Unlicense
// Created: 2026-04-08 00:05:11 +0200
// Last modified: 2026-04-08T00:09:29+0200

#define LOGGING_IMPLEMENTATION
#include "single_header/logging.h"

int main(int argc, char *argv[])
{
  (void)argc;
  (void)argv;
  logging_configure("logging test", LOG_DEBUG);
  debug("this is a test of a debug message");
  info("this is a test of an info message");
  warning("this is a test of a warning message");
  error("this is a test of an error message");
  return 0;
}
