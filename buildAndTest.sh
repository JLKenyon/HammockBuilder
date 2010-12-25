#!/bin/bash

cabal configure && cabal build && cabal install && ./dist/build/testHammock/testHammock && runghc sample/simple_01/simple.hs
