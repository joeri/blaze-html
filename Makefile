
## Config
#########

# GHC = ghc-6.12.3
GHC = ghc-7.0.0.20100924

GHCI = ghci-6.12.3


## All benchmarks
#################

benchmark:
	$(GHC) --make -O2 -fforce-recomp -main-is HtmlBenchmarks benchmarks/HtmlBenchmarks.hs
	./benchmarks/HtmlBenchmarks --resamples 10000

bench-constructor-html:
	$(GHC) --make -O2 -fforce-recomp -ilib/binary-0.5.0.2/src -main-is Main benchmarks/bigtable/constructor.hs
	./benchmarks/bigtable/constructor --resamples 10000

bench-closure-constructor-html:
	$(GHC) --make -O2 -fforce-recomp -ilib/binary-0.5.0.2/src -main-is Main benchmarks/bigtable/closure-constructor.hs
	./benchmarks/bigtable/closure-constructor --resamples 10000

core-closure-constructor-html:
	$(GHC)-core -- --make -O2 -fforce-recomp -ilib/binary-0.5.0.2/src -main-is Main benchmarks/bigtable/closure-constructor.hs

bench-builder:
	$(GHC) --make -O2 -fforce-recomp -ilib/binary-0.5.0.2/src -main-is Utf8Builder benchmarks/Utf8Builder.hs
	./benchmarks/Utf8Builder --resamples 10000

benchmarkserver:
	$(GHC) --make -threaded -O2 -fforce-recomp -idoc/examples -ibenchmarks -main-is BenchmarkServer doc/examples/BenchmarkServer.lhs

snapbenchmarkserver:
	$(GHC) --make -threaded -O2 -fforce-recomp -idoc/examples -ibenchmarks -main-is SnapBenchmarkServer doc/examples/SnapBenchmarkServer.hs

bench-new-builder:
	$(GHC) --make -O2 -fforce-recomp -ilib/binary-0.5.0.2/src -main-is Data.Binary.NewBuilder lib/binary-0.5.0.2/src/Data/Binary/NewBuilder.hs
	./lib/binary-0.5.0.2/src/Data/Binary/NewBuilder --resamples 10000

core-new-builder:
	ghc-core -- --make -O2 -fforce-recomp -ilib/binary-0.5.0.2/src -main-is Data.Binary.NewBuilder lib/binary-0.5.0.2/src/Data/Binary/NewBuilder.hs

bench-bigtable-non-haskell:
	ruby benchmarks/bigtable/erb.rb
	ruby benchmarks/bigtable/erubis.rb
	php -n benchmarks/bigtable/php.php

# Generate the actual HTML combinators
combinators:
	runghc Util/GenerateHtmlCombinators.hs

# Run the tests
test:
	runghc -itests tests/TestSuite.hs

# Copy the docs the website directory
website-docs:
	cabal haddock
	rm -rf website/docs
	cp -r dist/doc/html/blaze-html website/docs

# The current target used
CURRENT=$(shell ls *.cabal | sed 's/\.cabal//')

hide-cabal-files:
	cabal clean
	mv ${CURRENT}.cabal ${CURRENT}.cabal.${CURRENT}
	mv Setup.hs Setup.hs.${CURRENT}

blaze-html: hide-cabal-files
	mv blaze-html.cabal.blaze-html blaze-html.cabal
	mv Setup.hs.blaze-html Setup.hs

blaze-from-html: hide-cabal-files
	mv blaze-from-html.cabal.blaze-from-html blaze-from-html.cabal
	mv Setup.hs.blaze-from-html Setup.hs

# Cleanup
clean:
	rm -rf doc/examples/BenchmarkServer doc/examples/*.hi
	rm -rf benchmarks/HtmlBenchmarks benchmarks/*.hi
	rm -rf Text/Blaze/*.hi Text/Blaze/Html4/*.hi Text/Blaze/Html5/*.hi Text/Blaze/Renderer/*.hi Text/*.hi
	rm -rf Text/Blaze/*.o Text/Blaze/Html4/*.o Text/Blaze/Html5/*.o Text/Blaze/Renderer/*.o Text/*.o
