import Hammock

main = print $ project "HelloWorld" $ do
         output_dir "bin"
         exe "simple_01" $ do
           cpp "src/main.cpp"
           cpp "src/bar.cpp"
         exe "simple_foo" $ do
           cpp "src/foo.cpp"
