module drowbar.exception;

import std.exception;

class DrowbarException : Exception {
    this(string message, string file = __FILE__, int line = __LINE__){
        super(message, file, line);
    }
}

