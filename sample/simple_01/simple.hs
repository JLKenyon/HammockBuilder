import Hammock

main = do
  putStrLn "---------------------------------------"
  putStrLn "Single cpp:"
  print $ cpp "src/foo.cpp"

  putStrLn "---------------------------------------"
  putStrLn "Simple exe:"
  print $ exe "simple_01" $ do
         cpp "src/main.cpp"

  putStrLn "---------------------------------------"
  putStrLn "Simple project:"
  print $ project "HelloWorld" $ do
         exe "simple_01" $ do
           cpp "src/main.cpp"

  putStrLn "---------------------------------------"
  putStrLn "Complex project:"
  print $ project "HelloWorld" $ do
         output_dir "bin"
         exe "simple_01" $ do
           cpp "src/main.cpp"
           cpp "src/bar.cpp"
         exe "simple_foo" $ do
           cpp "src/foo.cpp"

  putStrLn "---------------------------------------"
  putStrLn "Dotted complex project:"
  putStrLn $ genDot $ project "HelloWorld" $ do
         output_dir "bin"
         exe "simple_01" $ do
           cpp "src/main.cpp"
           cpp "src/bar.cpp"
         exe "simple_foo" $ do
           cpp "src/foo.cpp"

