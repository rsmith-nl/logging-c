Logging for C
#############

:date: 2026-02-18
:tags: C programming, logging, public domain
:author: Roland Smith

.. Last modified: 2026-02-22T00:35:49+0100
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


Implementation
==============

By choice, the implementation is a lot simpler than the Python module.
Logging is only done to ``stderr``.


Usage
=====

Just copy the source files (``logging.h``, ``logging.c``) in to your project.
