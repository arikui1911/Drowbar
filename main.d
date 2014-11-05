static import drowbar.parser;
import drowbar;
import std.stdio;
import std.exception;
import std.getopt;


void main(string[] argv){
    try {
        auto help = false;
        auto ver = false;
        auto dumpTree = false;

        getopt(argv, std.getopt.config.bundling,
               "help|h", &help, "version|v", &ver,
               "dump-tree", &dumpTree,);

        if (help) {
            showHelp(argv[0]);
            return;
        }
        if (ver) {
            showVersion(argv[0]);
            return;
        }

        enforceEx!DrowbarException(argv.length == 2, "Wrong number of arguments");
        auto f = File(argv[1], "rt");

        auto machine = new Interpreter();
        drowbar.parser.parseFile(machine, f);

        if (dumpTree) {
            machine.dumpTree(stderr);
            return;
        }

        machine.run();
    } catch (ErrnoException e) {
        stderr.writefln("%s: No such file or directory - `%s'", argv[0], argv[1]);
    } catch (DrowbarException e) {
        stderr.writefln("%s: %s", argv[0], e.msg);
        stderr.writefln("%s: Usage: %s filename", argv[0], argv[0]);
    }
}

private void showHelp(string prog){
    stderr.writefln(`Usage: %s filename
    -h --help         show this help
    -v --version      show version
       --dump-tree    dump parsed AST (do not run)
`, prog);
}

private void showVersion(string prog){
    stderr.writefln("%s - 0.0.1", prog);
}

