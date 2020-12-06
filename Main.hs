module Main where

import qualified Data.Map as M
import Text.Parsec
import Text.Parsec.String (Parser)
import Control.Monad.State
import Data.Foldable (traverse_)
import System.Environment (getArgs)
import qualified Data.Word8 as W

data Expr = Comment | Rgt | Lft | Incr | Decr | Output | Input | Loop [Expr] deriving (Show, Eq)
data Brainfuck = Brainfuck {
    index :: Int,
    tape :: M.Map Int W.Word8,
    exprs :: [Expr],
    output :: String
} deriving (Show, Eq)

parseRight :: Parser Expr
parseRight = char '>' >> return Rgt

parseLeft :: Parser Expr
parseLeft = char '<' >> return Lft

parseIncr :: Parser Expr
parseIncr = char '+' >> return Incr

parseDecr :: Parser Expr
parseDecr = char '-' >> return Decr

parseOutput :: Parser Expr
parseOutput = char '.' >> return Output

parseInput :: Parser Expr
parseInput = char ',' >> return Input

parseComment :: Parser Expr
parseComment = noneOf "+-<>.,[]" >> return Comment

parseLoop :: Parser Expr
parseLoop = do
    char '['
    exprs <- many1 $ try (parseRight <|> parseLeft <|> parseIncr <|> parseDecr <|> parseOutput <|> parseInput <|> parseLoop <|> parseComment)
    char ']'
    return $ Loop exprs

parseBrainfuck :: Parser Brainfuck
parseBrainfuck = do
    exprs <- many1 $ try (parseRight <|> parseLeft <|> parseIncr <|> parseDecr <|> parseOutput <|> parseInput <|> parseLoop <|> parseComment)
    return $ initialBrainfuck exprs

initialBrainfuck :: [Expr] -> Brainfuck
initialBrainfuck exprs = Brainfuck {
    index = 0,
    tape = M.empty,
    exprs = exprs,
    output = ""
}

runExpr :: Expr -> StateT Brainfuck IO String
runExpr Rgt = do
    bf <- get
    put $ bf { index = index bf + 1 }
    return $ output bf
runExpr Lft = do
    bf <- get
    put $ bf { index = index bf - 1 }
    return $ output bf
runExpr Incr = do
    bf <- get
    put $ bf { tape = M.insertWith (+) (index bf) 1 (tape bf)}
    return $ output bf
runExpr Decr = do
    bf <- get
    put $ bf { tape = M.insertWith (+) (index bf) 255 (tape bf)}
    return $ output bf
runExpr Output = do
    bf <- get
    let toOutput = M.lookup (index bf) (tape bf)
    case toOutput of
        Just c -> do
            bf <- get
            put $ bf { output = output bf ++ [toEnum $ fromEnum c]}
            return $ output bf
        Nothing -> return $ output bf
runExpr Input = do
    bf <- get
    toStore <- liftIO getChar
    put $ bf { tape = M.insert (index bf) (toEnum $ fromEnum toStore) (tape bf)}
    return $ output bf
runExpr Comment = gets output
runExpr (Loop exprs) = do
    bf <- get
    case M.lookup (index bf) (tape bf) of
        Just 0 -> gets output
        Just _ -> do 
            traverse_ runExpr exprs
            bf <- get
            case M.lookup (index bf) (tape bf) of
                Just 0 -> gets output
                Just _ -> runExpr (Loop exprs)
                Nothing -> gets output
        Nothing -> gets output

run :: StateT Brainfuck IO String
run = do
    bf <- get
    traverse_ runExpr (exprs bf)
    gets output

main :: IO ()
main = do
    args <- getArgs
    let fname = head args
    contents <- readFile fname
    let Right parsed = parse parseBrainfuck fname contents
    output <- evalStateT run parsed
    putStrLn output