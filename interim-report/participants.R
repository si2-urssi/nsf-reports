library(tidyverse)
library(janitor)
berkeley <- read_csv("berkeley_participants.csv")
chicago <-
  read_csv("chicago_particpants.csv") %>% select(name = Name, affiliation)

all_workshops <- bind_rows(berkeley, chicago)

dupes <- all_workshops %>% get_dupes(name)

df2 <- dupes %>% filter(is.na(affiliation))
combined_participants <-
  anti_join(all_workshops, df2, by = c("name", "affiliation")) %>% arrange(name)


# Final list of deduplicated participants
write_csv(combined_participants, path = "combined_participants.csv")

# List of unique institutions
institutions <- combined_participants %>% arrange(affiliation) %>% filter(!is.na(affiliation)) %>% pull(affiliation) %>%  unique

filec <- file("institutions.txt")
writeLines(institutions, filec)
close(filec)
