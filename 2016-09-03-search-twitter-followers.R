library(rtweet)
library(stringi)
library(dplyr)
library(pbapply)


friends = get_friends("noamross")
followers = get_followers("noamross")
tweeps_id = unique(c(friends$ids$value, followers$id$value))
tweeps_info = lookup_users(friends$ids$value)

nyc_regex = "(NYC|New York|Gotham|Brooklyn|Kings|Staten|Prospect|Crown Heights|Park Slope|Manhattan|Bronx|Stuy|Queens\\b|BK\\b|\\bNY\\b)"

ny_tweeps_info = tweeps_info$users %>%
  filter(stri_detect_regex(name, nyc_regex, case_insensitive=TRUE) |
         stri_detect_regex(screen_name, nyc_regex, case_insensitive=TRUE) |
         stri_detect_regex(location, nyc_regex, case_insensitive=TRUE) |
         stri_detect_regex(description, nyc_regex, case_insensitive=TRUE))

ny_tweeps_info %>% select(name, screen_name, description, location) %>% arrange(name) %>%  print(n=250)


ny_tweeps_friends = pblapply(ny_tweeps_info$user_id, function(x) {get_friends(x); Sys.sleep(61))

disease_regex = "(disease|parasite|outbreak|spillover|infect|patho(gen|ology)|\\svet(\\s|er)|vir(al|us))"
disease_tweeps_info = tweeps_info$users %>%
  filter(stri_detect_regex(description, disease_regex))

disease_tweeps_info %>% select(name, screen_name, description, location) %>% arrange(location) %>%  print(n=150)
