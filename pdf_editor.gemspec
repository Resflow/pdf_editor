# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pdf_editor/version'

Gem::Specification.new do |spec|
  spec.name          = "pdf_editor"
  spec.version       = PdfEditor::VERSION
  spec.authors       = ["bradwheel"]
  spec.email         = ["bradley.m.wheel@gmail.com"]
  spec.summary       = %q{Edits Pdf's}
  spec.description   = %q{Edits Pdf's}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'prawn',         '1.2.1'
  spec.add_dependency 'pdf-reader',    '1.3.3'
  spec.add_dependency 'docsplit',      '0.7.5'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pdf-inspector'
  spec.add_development_dependency 'pry'
end
