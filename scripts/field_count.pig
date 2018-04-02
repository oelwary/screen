all_data = load 'data_flat' as (line);
words = foreach all_data GENERATE TOKENIZE(line) as word;
field_counts = foreach words generate SIZE(word) as field_count;
field_counts_grouped = GROUP field_counts ALL;
average_field_count = foreach field_counts_grouped generate AVG(field_counts.field_count) as avg_field_count;
store average_field_count into 'fc' using PigStorage(',');
fs -getmerge fc /results_export/average_field_count.csv

