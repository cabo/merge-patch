require_relative '../lib/merge-patch'

data = DATA.read.lines.map(&:chomp)
cols = data.shift.scan(/\w*\s+/).map(&:size)
data.shift                      # discard ---

examples = [["", "", ""]]
data.each { |line|
  s = cols.map { |c| line.slice!(0, c) } << line
  if s.shift == ""
    examples << ["", "", ""]
  else
    examples.last.each_with_index do |ex, i|
      ex << s[i].strip
    end
  end
}

require 'json'
triples = examples.map do |ex|
  ex.map {|s| JSON.load(s) rescue "Invalid Example"}
end

# This check should not output anything:
triples.each do |o, p, r|
  res = merge_patch(o, p)
  if r != res
    puts "Mismatch: "
    puts "orig:     #{JSON.dump(o)}"
    puts "patch:    #{JSON.dump(p)}"
    puts "draft:    #{JSON.dump(r)}"
    puts "actual:   #{JSON.dump(res)}"
  end
end

=begin old-version
             ORIGINAL        PATCH           RESULT
             ------------------------------------------
             {"a":"b"}       {"a":"c"}       {"a":"c"}

             {"a":"b"}       {"b":"c"}       {"a":"b",
                                              "b":"c"}

             {"a":"b"}       {"a":null}      {}

             {"a":"b",       {"a":null}      {"b":"c"}
              "b":"c"}

             {"a":["b"]}     {"a":"c"}       {"a":"c"}

             {"a":"c"}       {"a":["b"]}     {"a":["b"]}

             {"a": {         {"a": {         {"a": {
               "b": "c"}       "b": "d",       "b": "d"
             }                 "c": null}      }
                             }               }

             {"a": [         {"a": [1]}      {"a": [1]}
               {"b":"c"}
              ]
             }

             ["a","b"]       ["c","d"]       ["c","d"]

             {"a":"b"}       ["c"]           ["c"]

             [1,2]           {"a":"b",       {"a":"b"}
                              "c":null}

             {"e":null}      {"a":1}         {"e":null,
                                              "a":1}

             {}              {"a": {         {"a": {
                               "bb": {         "bb": {
                                "ccc":null   }}}
                             }}}

             {"a":"foo"}     {"b": [         {"a":"foo",
                               3,             "b": [3, {}]
                               null,         }
                               {"x":null}
                              ]
                             }

             [1,2]           [1,null,3]      [1,3]

             [1,2]           [1,null,2]      [1,2]

             {"a":"b"}       {"a": [         {"a": [
                               {"z":1,         {"z":1}
                                "b":null      ]
                               }             }
                              ]
                             }

             {"a":"foo"}     null            Invalid Patch

             {"a":"foo"}     "bar"           Invalid Patch
=end

__END__
   ORIGINAL        PATCH           RESULT
   ------------------------------------------
   {"a":"b"}       {"a":"c"}       {"a":"c"}

   {"a":"b"}       {"b":"c"}       {"a":"b",
                                    "b":"c"}

   {"a":"b"}       {"a":null}      {}

   {"a":"b",       {"a":null}      {"b":"c"}
    "b":"c"}

   {"a":["b"]}     {"a":"c"}       {"a":"c"}

   {"a":"c"}       {"a":["b"]}     {"a":["b"]}

   {"a": {         {"a": {         {"a": {
     "b": "c"}       "b": "d",       "b": "d"
   }                 "c": null}      }
                   }               }

   {"a": [         {"a": [1]}      {"a": [1]}
     {"b":"c"}
    ]
   }

   ["a","b"]       ["c","d"]       ["c","d"]

   {"a":"b"}       ["c"]           ["c"]

   {"a":"foo"}     null            null

   {"a":"foo"}     "bar"           "bar"

   {"e":null}      {"a":1}         {"e":null,
                                    "a":1}

   [1,2]           {"a":"b",       {"a":"b"}
                    "c":null}

   {}              {"a":            {"a":
                    {"bb":           {"bb":
                     {"ccc":          {}}}
                      null}}}
