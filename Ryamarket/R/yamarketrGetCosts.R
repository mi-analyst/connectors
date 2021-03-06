#Получаем расход
yamarketrGetCosts <- function(Campaigns,
                              fromDate = format(Sys.Date()-8, "%d-%m-%Y"),
                              toDate = format(Sys.Date()-1, "%d-%m-%Y"),
                              Login = NULL, TokenPath = getwd(), places = 0, model = 0, fetchBy = "daily"){

  result <- data.frame(date = character(0),
                       id = character(0),
                       placeGroup = numeric(0),
                       clicks = numeric(0),
                       spending = numeric(0),
                       shows = numeric(0)
  )

  nrowCampaigns <- ifelse((is.vector(Campaigns) | is.numeric(Campaigns) | is.character(Campaigns)), length(Campaigns), nrow(Campaigns))
  if (nrowCampaigns > 1){
    pb   <- txtProgressBar(1, nrowCampaigns, style=3)
  }
  #Авторизация
  Token <- yamarketrAuth(Login = Login, TokenPath = TokenPath, NewUser = FALSE)$access_token
  for(i in 1:nrowCampaigns){
    if (nrowCampaigns > 1){
      setTxtProgressBar(pb, i)
    }
    campaignId <- ifelse(is.vector(Campaigns), Campaigns[i], Campaigns$id[i])
    query <- paste0("https://api.partner.market.yandex.ru/v2/campaigns/",
                    campaignId,
                    "/stats/main",
                    paste0("-",fetchBy),
                    ".json?fromDate=", fromDate,
                    "&toDate=",toDate,
                    "&fields=mobile,shows",ifelse(model == 1, ",model", ""),
                    ifelse(places == 1, "&byPlaces=1", ""))
    raw <- httr::RETRY("GET", 
                       url = query, 
                       httr::add_headers(Authorization = paste("OAuth oauth_token=", Token,
                                                               ",oauth_client_id=8943390a15784189a8538ce5c4d57dfb")),
                       times = 5, 
                       pause_min = 20, 
                       terminate_on_success=FALSE
                      )
    data <- jsonlite::fromJSON(httr::content(raw,type="text", encoding = "UTF-8"))
    if(raw$status_code > 200){
      stop(paste(data$errors$code, "-", data$errors$message, "-", campaignId))
    }
    if(is.null(data$mainStats$clicks)) next
    result <- rbind(result, data.frame(date = as.Date(data$mainStats$date),
                                       id = as.character(campaignId),
                                       placeGroup = data$mainStats$placeGroup,
                                       clicks = data$mainStats$clicks,
                                       shows = as.integer(data$mainStats$shows),
                                       spending = data$mainStats$spending,
                                       stringsAsFactors = FALSE)
    )
  }
  result$placeGroup <- plyr::mapvalues(result$placeGroup, from=c(3,4,5,6,7,9,10,11),
                                       to=c("поиск Яндекс.Маркета", "карточки товаров",
                                            "Яндекс.Маркет, кроме карточек товаров",
                                            "поиск Яндекса, Яндекс.Картинки, сторонние сайты и сервисы",
                                            "предложение по умолчанию", "блок Топ-6", "остальные места на карточке", "иное"),
                                       warn_missing=FALSE)
  message(paste("\nЗагрузка завершена!"))
  return(result)
}
