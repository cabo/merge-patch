Gem::Specification.new do |s|
  s.name = "merge-patch"
  s.version = "0.1.0"
  s.summary = "RFC 7396 merge-patch"
  s.description = %q{merge-patch implements a library and a command-line interface to RFC 7396 Merge-Patch}
  s.author = "Carsten Bormann"
  s.email = "cabo@tzi.org"
  s.license = "Apache-2.0"
  s.homepage = "https://github.com/cabo/merge-patch"
  s.has_rdoc = false
  s.files = Dir['lib/**/*.rb'] + %w(merge-patch.gemspec) + Dir['bin/**/*']
  s.executables = Dir['bin/**/*'].map {|x| File.basename(x)}
  s.required_ruby_version = '>= 1.9.2'

  s.require_paths = ["lib"]
end
