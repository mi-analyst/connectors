yamarketrAuth <- function(Login = NULL, NewUser = FALSE, TokenPath = getwd()) {

  # Проверяем папку хранения токена

  if (!dir.exists(TokenPath)) {
    dir.create(TokenPath)
  }

  # Загружаем token из папки
  if (NewUser == FALSE && file.exists(paste0(paste0(TokenPath, "/", Login, ".yamarketAuth.RData")))) {
    message("Load token from ", paste0(paste0(TokenPath, "/", Login, ".yamarketAuth.RData")))
    load(paste0(TokenPath, "/", Login, ".yamarketAuth.RData"))
    # Проверяем срок действия токена
    if (as.numeric(token$expire_at - Sys.time(), units = "days") < 30) {
      message("Auto refresh token")
      token_raw  <- httr::POST("https://oauth.yandex.ru/token", body = list(grant_type="refresh_token",
                                                                            refresh_token = token$refresh_token,
                                                                            client_id = "8943390a15784189a8538ce5c4d57dfb",
                                                                            client_secret = "edef5009ede4406daa4abb9d7b3b77eb"), encode = "form")
      # Проверяем ошибки
      if (!is.null(token$error_description)) {
        stop(paste0(token$error, ": ", token$error_description))
      }
      # парсим токен
      new_token <- httr::content(token_raw)
      # сохраняем информацию срока действия токена
      new_token$expire_at <- Sys.time() + as.numeric(token$expires_in, units = "secs")

      # сохраняем токен в файл
      save(new_token, file = paste0(TokenPath, "/", Login, ".yamarketAuth.RData"))
      message("Token saved in file ", paste0(TokenPath, "/", Login, ".yamarketAuth.RData"))

      return(new_token)
    } else {
      message("Token expire in ", round(as.numeric(token$expire_at - Sys.time(), units = "days"), 0), " days")

      return(token)
    }
  }
  # если токен не найден в файле то получаем код и проходим всю процедуру
  browseURL(paste0("https://oauth.yandex.ru/authorize?response_type=code&client_id=8943390a15784189a8538ce5c4d57dfb&redirect_uri=https://mrykin.github.io/yamarketr/getToken/&force_confirm=", as.integer(NewUser), ifelse(is.null(Login), "", paste0("&login_hint=", Login))))
  # запрашиваем код
  temp_code <- readline(prompt = "Enter authorize code:")

  # проверка введённого кода
  while(nchar(temp_code) != 7) {
    message("Проверочный код введённый вами не является 7-значным, повторите попытку ввода кода.")
    temp_code <- readline(prompt = "Enter authorize code:")
  }

  token_raw <- httr::POST("https://oauth.yandex.ru/token", body = list(grant_type="authorization_code",
                                                                       code = temp_code,
                                                                       client_id = "8943390a15784189a8538ce5c4d57dfb",
                                                                       client_secret = "edef5009ede4406daa4abb9d7b3b77eb"), encode = "form")
  # парсим токен
  token <- httr::content(token_raw)
  token$expire_at <- Sys.time() + as.numeric(token$expires_in, units = "secs")
  # проверяе на ошибки
  if (!is.null(token$error_description)) {
    stop(paste0(token$error, ": ", token$error_description))
  }
  # сохраняем токен в файл
  save(token, file = paste0(TokenPath, "/", Login, ".yamarketAuth.RData"))
  message("Token saved in file ", paste0(TokenPath, "/", Login, ".yamarketAuth.RData"))

  return(token)
}
