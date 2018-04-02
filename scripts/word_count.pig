all_data = load 'data_flat' as (line);
words = foreach all_data GENERATE FLATTEN(TOKENIZE(line)) as word;
all_word_grouped = group words by word;
word_count = foreach all_word_grouped generate group, COUNT(words);
store word_count into 'wc' using PigStorage(',');
fs -getmerge wc /results_export/word_count.csv
