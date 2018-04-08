defmodule Huffman do

#text that contains characters we want to encode
def sample() do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
end

def text, do: 'this is something that we should encode'

def test do
  sample = sample()
  tree = tree(sample)
  encode = encode_table(tree)
  decode = decode_table(tree)
  text = text()
  seq = encode(text, encode)
  decode(seq, decode)
end

#create Huffman tree given a sample text
#sample is a list of characters [102,111,111]
def tree(sample) do
  freq = freq(sample)
  huffman(freq)
end

#return the frequency of each character in sample
def freq(sample) do freq(sample, []) end
def freq([], freq) do freq end      #we have gone through all characters in sample and can return the frequency
def freq([char | rest], freq) do
  freq(rest, update(char, freq))
end
#calculates the frequency in a list
#returns a list of frequencies for each character
def update(char, []) do [{char, 1}] end   #character only existed once in the list
def update(char, [{char, f} | freq]) do   #character exist in our frequency list
  [{char, f+1} | freq]                    #frequency is added by one
end
def update(char, [elem|freq]) do          #go through frequency list and see if we have
  [elem | update(char, freq)]
end

#build a huffman tree
def huffman(freq) do
  sorted = List.keysort(freq, 1)
  huffmanTree(sorted)
end
#create the tree based on the frequencies
def huffmanTree([{tree, _}]) do tree end
def huffmanTree([{t1, f1}, {t2, f2} | rest]) do     #if we have at least two element in the frequency list
  huffmanTree(insert({{t1, t2}, f1 + f2}, rest))    #we add the frequencies together, we want the tree to be sorted
end
def insert({c1, f1}, []) do [{c1, f1}] end   #the last entry in the tree, at the top
def insert({c1, f1}, [{c2, f2} | rest]) when f1 < f2 do
  [{c1, f1}, {c2, f2} | rest]
end
def insert({c1, f1}, [{c2, f2} | rest]) do
  [{c2, f2} | insert({c1, f1}, rest)]
end

#create an encoding table containing mapping from characters to codes
def encode_table(tree) do
  #the empty list is the list containing 0 and 1 for the characters
  code(tree, [])
end
#get the number sequence
def code({left, right}, path) do
  l = code(left, [0|path])
  r = code(right, [1|path])
  l ++ r
end
#get character for the sequence
def code(a, code) do
  [{a, Enum.reverse(code)}]
end

#create a decoding table containing the mapping from codes to characters
def decode_table(tree) do
  code(tree, [])
end

#encode text using the mapping in the table
#return sequence of bits
def encode([], _) do [] end
def encode([char|rest], table) do
  {_, code} = List.keyfind(table, char, 0)  #lookup a character
  code ++ encode(rest, table)
end

#decode bit sequence using mapping in table
#return a text
def decode([], _) do [] end
def decode(seq, table) do
  {char, rest} = decode_char(seq, 1, table)
  [char | decode(rest, table)]
end

#decode the table
def decode_char(seq, n, table) do
  {code, rest} = Enum.split(seq, n) #split the sequence into two, leaving n elements in the first one

  case List.keyfind(table, code, 1) do
    {char, _} ->
      {char, rest}
  nil ->
    decode_char(seq, n+1, table)
  end
end

end
