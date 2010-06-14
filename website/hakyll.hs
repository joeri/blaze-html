module Main where

import Text.Hakyll (hakyll)
import Text.Hakyll.Render (css, static, renderChain)
import Text.Hakyll.File (directory)
import Text.Hakyll.CreateContext (createPage)
import Control.Monad (forM_)

main = hakyll "http://example.com" $ do
    -- Static stuff.
    directory css "css"
    directory static "images"

    -- Render everything.
    mapM_ render [ "index.markdown"
                 , "tutorial.lhs"
                 , "about.markdown"
                 ]
  where
    render = renderChain ["templates/default.html"] . createPage