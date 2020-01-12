#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS build
WORKDIR /src
COPY ["GithubActionDockerTest.csproj", ""]
RUN dotnet restore "./GithubActionDockerTest.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "GithubActionDockerTest.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "GithubActionDockerTest.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "GithubActionDockerTest.dll"]
