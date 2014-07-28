Gem::Specification.new do |s|
  s.name          = 'concur'
  s.version       = '0.0.0'
  s.date          = '2014-05-14'
  s.summary       = 'Concur'
  s.description   = 'in-line model validation in rails'
  s.authors       = ['David M Good']
  s.email         = 'akabigbro@gmail.com'
  s.files         = ['lib/concur.rb']
  s.homepage      = 'http://github.com/akabigbro/concur'
  s.license       = 'Apache License, Version 2.0'
  s.add_runtime_dependency 'activemodel', ["3.2.13"]
  s.add_development_dependency 'activemodel', ["3.2.13"]
end
