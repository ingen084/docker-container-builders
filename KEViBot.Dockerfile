FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /app

RUN apt update && apt install -y git
RUN git clone https://github.com/ingen084/KyoshinEewViewerIngen.git
RUN cd KyoshinEewViewerIngen && git submodule init && git submodule update

WORKDIR /app/KyoshinEewViewerIngen/src/Sandboxes/SlackBot
RUN dotnet publish -c Release -r linux-x64 -o /app/out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
ENV TZ=Asia/Tokyo
WORKDIR /app
RUN apt-get update; apt-get install libfontconfig1 libfreetype6 libglib2.0-bin libssl-dev ca-certificates -y
RUN rm -rf /var/lib/apt/lists/*
COPY --from=build-env /app/out .
CMD ["dotnet", "SlackBot.dll"]
