require 'rake/clean'
require 'pathname'
require 'stringio'

RESULT = "drowbar.exe"
IMP    = FileList["import/drowbar/parser/parser.d", "import/**/*.d"]
OBJ    = IMP.ext(".obj")
MAIN   = "main.d"
IMPORT = ["./import"]

CLEAN.include OBJ
CLOBBER.include RESULT

def import_paths
  IMPORT.map{|x| "-I#{x}" }
end

def caper_filter(filename)
  f = StringIO.new
  in_switch = false
  File.foreach(filename) do |line|
    case line
    when /\A\s*module\s+drowbar\.parser\.parser\s*;/
      # Insert import directive after module decleration.
      f.puts line
      f.puts
      f.puts "import drowbar.ast;"
      f.puts "import std.variant;"
    when /\A\s*switch\(nonterminal_index\)/
      # caper generate `no default label' switch, but it is depecated.
      # Insert default with assert(0).
      f.puts line
      in_switch = true
    when /\A(\s*)}/
      if in_switch
        f.puts "#{$1}default: assert(0);"
        in_switch = false
      end
      f.puts line
    else
      f.puts line
    end
  end
  f.string
end


file RESULT => OBJ + [MAIN] do |t|
  sh "dmd", "-g",  *import_paths(), "-of#{t.name}", *t.prerequisites
end

task :run => OBJ + [MAIN] do |t|
  sh "dmd", "-g",  *import_paths(), *t.prerequisites.insert(t.prerequisites.find_index{|x| x == MAIN }, "-run")
end

task :unittest => OBJ do |t|
  sh "dmd", "-g",  "-unittest", "-main", *import_paths(), "-of#{t.name}", *t.prerequisites
end

rule '.obj' => '.d' do |t|
  sh "dmd", "-g", *import_paths(), "-c", "-of#{t.name}", t.source
end

rule '.d' => '.cpg' do |t|
  dir = Pathname.new("./import")
  src, dest = [t.source, t.name].map{|x| Pathname.new(x).relative_path_from(dir).to_path }
  chdir(dir){ sh "caper", "-d", src, dest }
  new_content = caper_filter(t.name)
  File.open(t.name, 'w'){|w| w.puts new_content }
end

task 'tryrun' => [RESULT] do |t|
  sh RESULT, "src.drb"
end


task default: 'tryrun'

