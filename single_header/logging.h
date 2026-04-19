// file: logging.h
// vim:fileencoding=utf-8:ft=c:tabstop=2
// This is free and unencumbered software released into the public domain.
//
// Author: R.F. Smith <rsmith@xs4all.nl>
// SPDX-License-Identifier: Unlicense
// Created: 2024-08-31 23:25:54 +0200
// Last modified: 2026-04-19T14:20:11+0200

#pragma once
#include <stdbool.h>

// Requirement: ISO/IEC 9899:1999 (“ISO C99”).

enum {
  LOG_NOTSET = 0,
  LOG_CRITICAL = 10,
  LOG_ERROR = 20,
  LOG_WARNING = 30,
  LOG_INFO = 40,
  LOG_DEBUG = 50
};

#ifdef __cplusplus
extern "C" {
#endif

// Call this function before any of the other logging calls below.
// The “name” is prepended to each log message.
// Every message with a “level” equal or lower than the given value is printed.
// If “level” is 0, the logging level is set to LOG_WARNING.
extern void logging_configure(char *name, int level);

// Check if the logging level is ≥ the given level.
extern bool levelge(int level);

// Debug message. For developer infomation.
extern void debug(char *fmt, ...);

// Informational message.
extern void info(char *fmt, ...);

// An indication that something unexpected happened.
extern void warning(char *fmt, ...);

// Due to a more serious problem, the software has not been able to perform some function.
extern void error(char *fmt, ...);

// A problem so serious that the program cannot continue and will be aborted.
extern void critical(char *fmt, ...);

#ifdef __cplusplus
}
#endif

#ifdef LOGGING_IMPLEMENTATION

#include <stdint.h>
#include <stdbool.h>
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include <unistd.h>

static char log_name[256] = {0};
static const char *prefix = "#%s %s: ";
static int log_level = LOG_WARNING;

void logging_configure(char *name, int level)
{
  assert(level >= 0);
  if (name) {
    strncpy(log_name, name, 255);
  }
  if (level > 0) {
    log_level = level;
  }
}

bool levelge(int level)
{
  return log_level >= level;
}

void debug(char *fmt, ...)
{
  if (log_level < LOG_DEBUG) {
    return;
  }
  va_list args = {0};
  assert(fmt);
  fprintf(stderr, prefix, log_name, "DEBUG");
  va_start(args, fmt);
  vfprintf(stderr, fmt, args);
  fputs("\n", stderr);
  fflush(stderr);
  va_end(args);
}

void info(char *fmt, ...)
{
  if (log_level < LOG_INFO) {
    return;
  }
  va_list args = {0};
  assert(fmt);
  fprintf(stderr, prefix, log_name, "INFO");
  va_start(args, fmt);
  vfprintf(stderr, fmt, args);
  fputs("\n", stderr);
  fflush(stderr);
  va_end(args);
}

void warning(char *fmt, ...)
{
  if (log_level < LOG_WARNING) {
    return;
  }
  va_list args = {0};
  assert(fmt);
  fprintf(stderr, prefix, log_name, "WARNING");
  va_start(args, fmt);
  vfprintf(stderr, fmt, args);
  fputs("\n", stderr);
  fflush(stderr);
  va_end(args);
}

void error(char *fmt, ...)
{
  if (log_level < LOG_ERROR) {
    return;
  }
  va_list args = {0};
  assert(fmt);
  fprintf(stderr, prefix, log_name, "ERROR");
  va_start(args, fmt);
  vfprintf(stderr, fmt, args);
  fputs("\n", stderr);
  fflush(stderr);
  va_end(args);
}

void critical(char *fmt, ...)
{
  if (log_level < LOG_CRITICAL) {
    return;
  }
  va_list args = {0};
  assert(fmt);
  fprintf(stderr, prefix, log_name, "CRITICAL");
  va_start(args, fmt);
  vfprintf(stderr, fmt, args);
  fputs("\n", stderr);
  fflush(stderr);
  va_end(args);
  abort();
}

#endif // LOGGING_IMPLEMENTATION
