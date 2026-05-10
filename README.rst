Logging for C
#############

:date: 2026-02-18
:tags: C programming, logging, public domain
:author: Roland Smith

.. Last modified: 2026-05-10T13:21:53+0200
.. vim:spelllang=en

Introduction
============

This code was inspired by the Python ``logging`` module.
That is, to provide different logging at different levels;

* critical (the software cannot continue and will be aborted)
* error (the software has not been able to perform a function)
* warning (something unexpected happened)
* info (informational message)
* debug (helps to show the running of the software; for the developer)


No AI policy
============

This code is by a human and for humans.
"AI" / LLM-generated rewrites and additions are not welcome.


Implementation
==============

By choice, the implementation is a lot simpler than the Python module.
Logging is directly done to ``stderr``. There is no separate formatter.


Usage
=====

Just copy the source files (``logging.h``, ``logging.c``) in to your project.

Alternatively, you can use this project as a *single header library*.
This variant can be found in the subdirectory ``single_header/logging.h``.
To use the single header library, copy the file ``logging.h`` from
``single_header/`` into your project.
In **one** of the C-files you use the single header library in, you should
define ``LOGGING_IMPLEMENTATION`` before including the library::

    #define LOGGING_IMPLEMENTATION
    #include "logging.h"

