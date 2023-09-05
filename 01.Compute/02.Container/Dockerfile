FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

RUN mkdir /app
WORKDIR /app

COPY ./webapp/bin/Release/net6.0/publish ./
COPY ./config.sh ./

RUN bash config.sh

EXPOSE 80
ENTRYPOINT ["dotnet", "webapp.dll"]